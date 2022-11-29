# OCR my files

This docker setup uses OcrMyPdf (tesseract) to automatically OCR pdf files and add a textlayer.
Generally the process looks like this:

You can find it on [docker hub](https://hub.docker.com/r/maschmann/ocr-my-files)

```bash
|-- /incoming # houses new pdf files
|-- /processed # will have files, OCR'ed and moved from incoming
|-- /done # renamed files from processed
|-- /raw # backupped (unchanged) files from incoming
```

## Configuration

Currently the only configuration you can add, is a folder mount.
Use following docker command to start with all configured folders.

```bash
$docker pull maschmann/ocr-my-files
$docker run -d \
  -it \
  --name ocr-my-files \
  --mount type=bind,source="$(pwd)"/incoming,target=/incoming \
  --mount type=bind,source="$(pwd)"/processed,target=/processed \
  --mount type=bind,source="$(pwd)"/done,target=/done \
  --mount type=bind,source="$(pwd)"/raw,target=/raw \
  --mount type=bind,source="$(pwd)"/config,target=/config \
  maschmann/ocr-my-files
```

Put a rename_config file in your config directory, to override the defaults, specified like this:

```bash
# rename_config_default
# specific types
# has to be an indexed array to keep order, instead of a hashmap 
# this allows you to have a "fallthrough" kind of logic:
# So, highly specific checks on top of less specific checks will first match 
# "sozialversicherung" and later on "versicherung" if no previous term matched

types=(
    "lohnart==gehalt"
    "meldebescheinigung==sozialversicherung"
    "sozialversicherung==sozialversicherung"
    "abfallgeb==abfallgebühren"
    "grundsteuer==grundsteuer"
    "wasser==wasser"
    "hauptuntersuchung==hauptuntersuchung"
    "lohnsteuerbescheinigung==lohnsteuer"
    "bausparvertrag==kontoauszug-bausparvertrag"
    "vorfinanzierungskredit==kontoauszug-vorfinanzierungskredit"
    "jahreskontoauszug==kontoauszug"
    "schornsteinfeger==kaminfeger"
    "kontoauszug==kontoauszug"
    "xxxxxxxxxxx==krankenkasse"
    "haftpflicht\-versicherung==haftpflichtversicherung"
    "hausratversicherung==hausratversicherung"
    "r\+v\-privatpolice==gebäudeversicherung"
    "rechtsschutzversicherung==rechtsschutzversicherung"
    "renteninformation==renteninformation"
    "apcoa==parken"
    "kraftfahrtversicherung==kfz-versicherung"
    "rechnung==rechnung"
    "lieferschein==rechnung"
    "versicherung==versicherung"
    "zeugnis==zeugnis"
    "gehalt==gehalt"
)

months["Januar"]="01"
months["Februar"]="02"
months["März"]="03"
months["April"]="04"
months["Mai"]="05"
months["Juni"]="06"
months["Juli"]="07"
months["August"]="08"
months["September"]="09"
months["Oktober"]="10"
months["November"]="11"
months["Dezember"]="12"
```
And make sure to add both definitions, since there is no selective overwriting.

## cron intervals

The default cron configuration is

```bash
0 * * * * root /ocr/ocr-my-files -i /incoming -o /processed -b /raw -s
* * * * * root /ocr/rename-pdf -i /processed -o /done -k
```

It's checking for new files to convert every full hour. It won't run double (semaphore logic) but you can provoke race conditions with a lot of large file, so I suggest not to go below 15 minute intervals. 
It is possible to override the cron file with a custom one by supplying a ```custom_cron``` file in your config mount.
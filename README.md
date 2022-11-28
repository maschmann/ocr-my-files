# OCR my files

This docker image uses OcrMyPdf (thesseract) to automatically OCR pdf files and add a textlayer.
Generally the process looks like this:

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
  maschmann/ocr-my-files
```
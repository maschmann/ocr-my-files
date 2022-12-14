FROM ubuntu:latest

# Install Cron and prerequisite OCR soft + German language
RUN apt-get update && \
apt-get -y install \
cron \
pdfgrep \
ocrmypdf \
tesseract-ocr-deu

# Create directories
RUN mkdir /incoming /processed /raw /done /ocr /config

# Add crontab file in the cron directory
COPY [ "src/ocr-cron", "src/filecheck-cron", "/etc/cron.d/" ]

# Add scripts
COPY [ "src/ocr-my-files", "src/rename-pdf", "src/filecheck", "src/rename_config_default", "/ocr/" ]

# Give execution rights the script files
RUN chmod +x /ocr/ocr-my-files /ocr/rename-pdf /ocr/filecheck
#RUN chmod ug+x /etc/cron.d/ocr-cron /etc/cron.d/filecheck-cron
RUN chmod 0644 /etc/cron.d/ocr-cron /etc/cron.d/filecheck-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
#CMD cron && tail -f /var/log/cron.log
ENTRYPOINT ["cron", "-f"]
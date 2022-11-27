FROM ubuntu:latest

# Create directories
RUN mkdir /incoming && mkdir /processed && mkdir /raw && mkdir /done && mkdir /ocr

# Add crontab file in the cron directory
ADD src/crontab /etc/cron.d/ocr-cron

# Add scripts
ADD src/ocr-my-files /ocr/ocr-my-files
ADD src/rename-pdf /ocr/rename-pdf

# Give execution rights on the cron job and files
RUN chmod 0644 /etc/cron.d/ocr-cron 
RUN chmod +x /ocr/ocr-my-files /ocr/rename-pdf

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Install Cron
RUN apt-get update
# Install prerequisite OCR soft + German language
RUN apt-get -y install cron pdfgrep ocrmypdf tesseract-ocr-deu

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
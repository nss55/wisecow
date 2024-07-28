FROM ubuntu:latest
# Update the package forst
RUN apt-get update && apt-get install -y \
    fortune cowsay netcat-openbsd

# Copy the shell script into the image
COPY wisecow.sh /wisecow.sh
RUN chmod +x /wisecow.sh

# Run the shell 
CMD ["/wisecow.sh"]

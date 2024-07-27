# Use the official Ubuntu base image
FROM ubuntu:latest

# Update the package list and install required packages
RUN apt-get update && apt-get install -y \
    fortune cowsay netcat-openbsd

# Copy the shell script into the image
COPY script.sh /script.sh

# Make the shell script executable
RUN chmod +x /script.sh

# Run the shell script
CMD ["/script.sh"]

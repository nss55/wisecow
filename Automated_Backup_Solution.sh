#!/bin/bash

SOURCE_DIR="/home/ubuntu/backup_directory"  
REMOTE_USER="ubuntu"           
REMOTE_HOST="13.127.195.254"               
REMOTE_DIR="/home/ubuntu/"  
LOG_FILE="./backup_report.log"     
DATE=$(date +"%Y-%m-%d_%H-%M-%S")       
BACKUP_FILE="backup_${DATE}.tar.gz"     


log_message() {
    echo "$(date): $1" | tee -a $LOG_FILE
}

# Create tar.gz archive of the source directory
log_message "Creating backup of $SOURCE_DIR..."
tar -czf $BACKUP_FILE -C $SOURCE_DIR .
if [ $? -eq 0 ]; then
    log_message "Backup archive created successfully."
else
    log_message "Failed to create backup archive."
    exit 1
fi

# Transfer the backup file to the remote server
log_message "Transferring backup to $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR..."
scp $BACKUP_FILE $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR
if [ $? -eq 0 ]; then
    log_message "Backup transferred successfully."
else
    log_message "Failed to transfer backup to remote server."
    exit 1
fi

# Clean up local backup file
log_message "Cleaning up local backup file..."
rm -f $BACKUP_FILE
if [ $? -eq 0 ]; then
    log_message "Local backup file removed successfully."
else
    log_message "Failed to remove local backup file."
fi
log_message "Backup process completed successfully."

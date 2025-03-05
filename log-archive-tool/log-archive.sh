#!/bin/bash

#Author: Sushil
#Date: 03/05/2025

#This script archives the logs

#Version: v1

# Check if the log directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <log-directory>"
  exit 1
fi

# Log directory provided by the user
LOG_DIR="$1"

# Check if the directory exists
if [ ! -d "$LOG_DIR" ]; then
  echo "Error: Directory $LOG_DIR does not exist."
  exit 1
fi

# Create a timestamp for the archive
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Define the archive file name
ARCHIVE_NAME="logs_archive_$TIMESTAMP.tar.gz"

# Define the archive directory
ARCHIVE_DIR="$LOG_DIR/archives"

# Create the archive directory if it doesn't exist
mkdir -p "$ARCHIVE_DIR"

# Compress the logs into a tar.gz file
tar -czf "$ARCHIVE_DIR/$ARCHIVE_NAME" -C "$LOG_DIR" .

# Log the date and time of the archive
echo "Logs archived on $(date) into $ARCHIVE_NAME" >> "$ARCHIVE_DIR/archive_log.txt"

# Print success message
echo "Logs archived successfully: $ARCHIVE_DIR/$ARCHIVE_NAME"
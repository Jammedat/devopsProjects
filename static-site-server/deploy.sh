#!/bin/bash

#Author: Sushil
#Date: 03/11/2025

#This script uses rsync to deploy the static site to the server

#Version: v1

# Define variables

LOCAL_DIR="/mnt/c/Users/darji/static-site" # path to the local directory containing the site files
REMOTE_DIR="/var/www/html" # path to the remote directory where the site will be deployed
REMOTE_USER="azureuser" # remote user with permissions to deploy the site
REMOTE_HOST="172.174.239.140" # IP address or hostname of the remote server
SSH_KEY="/home/sushil/.ssh/static_key.pem" # path to the SSH private key for authentication
NGINX_SERVICE="nginx" 

# Function to run command with error handling

run_command() {
    if ! "$@"; then
        echo "Error: Command $* failed"
        exit 1
    fi
}

# Ensure the remote directory exists and has correct permissions

run_command ssh -i "$SSH_KEY" "$REMOTE_USER@$REMOTE_HOST" "sudo mkdir -p $REMOTE_DIR"
run_command ssh -i "$SSH_KEY" "$REMOTE_USER@$REMOTE_HOST" "sudo chown -R $REMOTE_USER:$REMOTE_USER $REMOTE_DIR && sudo chmod -R 755 $REMOTE_DIR"

# Deploy the site using rsync

echo "Deploying site to $REMOTE_HOST..."

run_command rsync -e "ssh -i $SSH_KEY" -avz --delete "$LOCAL_DIR/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

# Set correct permissions after sync

run_command ssh -i "$SSH_KEY" "$REMOTE_USER@$REMOTE_HOST" "sudo chown -R $REMOTE_USER:$REMOTE_USER $REMOTE_DIR && sudo chmod -R 755 $REMOTE_DIR"

echo "Site deployed successfully."

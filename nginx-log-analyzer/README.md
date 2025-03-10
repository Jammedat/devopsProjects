# Nginx Log Analyser

This project is a simple command-line tool to analyze Nginx access logs. It's designed to practice basic shell scripting skills.

## Project Goal
The goal of this project is to create a shell script that reads an Nginx log file and provides specific information about the requests.

## Requirements
Create a shell script that reads the log file and provides the following information from the logfile:

- Top 5 IP addresses with the most requests
- Top 5 most requested paths
- Top 5 response status codes
- Top 5 user agents

## Usage
Clone or download this repository to your local machine.

Make the script executable by running the following command in your terminal:

```bash
chmod +x log-analyzer.sh
```

Run the script by providing the path to your Nginx log file:

```bash
./log-analyzer.sh <log-file-path>
```

## Note
Make sure you have the logfile


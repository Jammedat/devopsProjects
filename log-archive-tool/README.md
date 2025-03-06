# Log Archive Tool

This project is a simple command-line tool to archive log files by compressing them and storing them in a designated directory.

## Project Goal
The goal of this project is to create a shell script that archives log files by compressing them into tar.gz format and maintaining a history of archive operations.

## Requirements
The tool provides the following functionality:

- Provide the log directory as an argument when running the tool.

```bash
log-archive <log-directory>
```
- The tool should compress the logs in a tar.gz file and store them in a new directory.
- The tool should log the date and time of the archive to a file.

Example archive name:

```
logs_archive_20240816_100648.tar.gz
```

## Usage
Make the script executable:

```bash
chmod +x log-archive.sh
```
Run the script by providing the path to your log directory:

```bash
./log-archives.sh <log-directory>
```

### Example

```bash
./log-archives.sh /path/to/logs
```



## Archive Naming Convention
Archives are named using the following format:

```
logs_archive_YYYYMMDD_HHMMSS.tar.gz
```

Where:

- **YYYY**: Year
- **MM**: Month
- **DD**: Day
- **HH**: Hour (24-hour format)
- **MM**: Minutes
- **SS**: Seconds


## Note
Make sure you have appropriate permissions to:

- Read from the source log directory
- Create the `archives` directory
- Write to the `archives` directory


#!/bin/bash

#Author: Sushil
#Date: 03/05/2025

#This script archives the logs

#Version: v1

COUNTS=5

echo -e "\nTop ${COUNTS} IP addresses with the most requests:\n"

awk '{print $1}' nginx-logfile.txt | sort | uniq -c | sort -nr | awk '{print $2 " - " $1 " requests"}' | head -n ${COUNTS}

echo -e "\nTop ${COUNTS} most requested paths:\n"

awk '{print $7}' nginx-logfile.txt | sort | uniq -c | sort -nr | awk '{print $2 " - " $1 " requests"}' | head -n ${COUNTS}

echo -e "\nTop ${COUNTS} request status codes:\n"

grep -oE ' [1-5][0-9]{2}' nginx-logfile.txt | sort | uniq -c | sort -nr | awk '{print $2 " - " $1 " requests"}' | head -n ${COUNTS}

echo -e "\nTop ${COUNTS} user agents:\n"

awk -F\" '{print $6}' nginx-logfile.txt | sort | uniq -c | sort -nr | awk '{print $2 " - " $1 " requests"}' | head -n ${COUNTS}
#!/bin/bash

#Author: Sushil
#Date: 03/02/2025

#This script analyzes the basic server performance stats

#Version: v1

echo "# System Uptime Info #" 

uptime

echo 


echo "# Total CPU Usage Info #"


top -b -n1 | grep "Cpu(s)" | awk '{print "Usage: " $2 + $4 "%"}'

echo

echo "# Memory Usage Info #"

free | grep Mem | awk '{printf  "Total Memory: %d MB\nUsed Memory: %d MB\nFree Memory: %d MB\n", $2/1024, $3/1024, $4/1024}'

echo

echo "# Disk Usage Info #"

df -h | awk '$NF=="/"{printf "Total Disk: %d GB\nUsed Disk: %d GB\nFree Disk: %d GB\n", $2/1024/1024, $3/1024/1024, $4/1024/1024}'

echo 

echo "# Top 5 processes by CPU Usage #"

ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -6

echo

echo "# Top 5 processes by Memory Usage #"

ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -6



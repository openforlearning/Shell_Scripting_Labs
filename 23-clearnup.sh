#!/bin/bash

#Colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#Check User passed the source directory
source_dir=$1
days=${2:-14} # if user is not defining days, then defaults to 14 days

usage(){
    echo "Usage: $0 [source_dir] [days(optional, default to 4days)]${N}"
    exit 1
}

if [ -z "$source_dir" ]; then
    echo "ERROR: Missing Params"
    usage
fi


#Check Source Directory exists

if [ ! -d "$source_dir" ]; then
    echo "ERROR: $source_dir does not exist${N}"
fi

#Find the files older than 14 days
echo "Scanning files older than $days in $source_dir"

#Delete files
files_to_delete=$(find $source_dir -name "*.log" -type f -mtime +$days) 

if [ -z "$files_to_delete" ]; then
    echo "No log files found older than $days"
    exit 0
fi

while IFS= read -r line
do
    echo "File to be deleted: $line"
done <<< "$files_to_delete"

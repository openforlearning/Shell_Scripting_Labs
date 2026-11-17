#!/bin/bash

#Colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#Check User passed the source directory
source_dir=$1
dest_dir=$2
days=${3:-14} # if user is not defining days, then defaults to 14 days

usage(){
    echo "${R}Usage: $0 [source_dir] [dest_dir] [days(optional, default to 14days)]${N}"
    exit 1
}

if [ -z "$source_dir" ] || [ -z "$dest_dir" ]; then
    echo "ERROR: Missing source or dest"
    usage
fi


#Check Source & Destination directories exist

if [ ! -d "$source_dir" ]; then
    echo "ERROR: $source_dir does not exist${N}"
    exit 1
fi

if [ ! -d "$dest_dir" ]; then
    echo "ERROR: $dest_dir does not exist${N}"
    exit 1
fi

#Find the files older than 14 days
echo "Scanning files older than $days in $source_dir"

#Archive Files
files_to_archive=$(find $source_dir -name "*.log" -type f -mtime +$days) 

if [ -z "$files_to_archive" ]; then
    echo "No log files found older than $days"
    exit 0
fi

timestamp=$(date +%Y-%m-%d-%H-%M-%S)

file_name="$dest_dir/logs-$timestamp.tar.gz"

tar -cvzf $file_name $files_to_archive

if [ $? -ne 0 ]; then
	echo "Log archival is failed"
	exit 1
else
	echo "Logs are archived: $file_name"
	while IFS= read -r line
	do
		echo "File is going to be deleted: $line"
		rm -f $line
		echo "File deleted: $line"
	done <<< "$files_to_archive"
fi








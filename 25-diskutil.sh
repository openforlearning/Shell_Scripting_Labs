#!/bin/bash

#Just an algorithm
#Get the diskusage output
#Go thru output of each line
#Define threshold, check if more than threshold
#If utilization exceeds threshold, alert it in the termimal
#Configure alerts to be sent to Email, Slack..etc

disk_usage=$(df -hT | grep -v Filesystem)
threshold=20

# If you want to run this script in any AWS EC2 Instance, then take the private IP
# using curl https://169.254.169.254/latest/meta-data/local-ipv4 

while IFS= read -r line
do
    usage=$(echo $line | awk -F " " '{print $6}' | cut -d "%" -f1)
    partition=$(echo $line | awk -F " " '{print $7}')

    if [ "$usage" -ge "$threshold" ]
    then
        echo "ALERT: Disk usage on $partition is ${usage}%"
        message+="High disk usage on $partition: $usage \n"
    fi
done <<< $disk_usage

echo -e "$message"
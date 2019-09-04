#!/bin/sh
  
# This script can be used to manually add a network route.
# The script runs the command:
# 
# route -n add -net "${network}" -interface "${interface}"
#
# where network is $4 and interface is $5
#
# These variables will be templated by the 'git2jss' tool
#
#
# Date: @@DATE
# Version: @@VERSION
# Origin: @@ORIGIN
# Link: @@ORIGIN/commit/@@VERSION
#
# Released by JSS User: @@USER
#

network="${4}"
interface="${5}"

TIMEOUT=10

count=0

while [[ $count -lt ${TIMEOUT} ]]
do
    addr="$(ifconfig en1 inet | awk '$1 == "inet" {print $2}')"
    if [ ! -z "${addr}" ]
    then
        break
    else
        echo "Waiting $count seconds for $interface"
        count=$((count+1))
        sleep 1
    fi
done

if [[ $count -eq 10 ]]
then
    echo "Timed out."
    exit 1
else
    route -n add -net "${network}" -interface "${interface}"
    if [ $? -eq 0 ]
    then
        echo "Added route"
    else
        echo "Failed"
        exit 1
    fi
fi
#!/bin/bash

curl -s https://raw.githubusercontent.com/linuxautomations/scripts/master/common-functions.sh >/tmp/common-functions.sh
source /tmp/common-functions.sh

CheckRoot

CheckOS 7

which gcloud &>/dev/null
Stat $? "Checking Google Cloud CLI"

HNAME=$(hostname)
gcloud compute instances list 2>/dev/null| grep $HNAME &>/dev/null
if [ $? -ne 0 ]; then 
    PrintCenter "Please Open the coming URL, to create the and setup the LAB. Open the URL, and get the code and Paste it here"
    echo -e "\e[33m"
    gcloud auth login --quiet
    gcloud compute instances list | grep $HNAME &>/dev/null
    if [ $? -ne 0 ]; then 
        Stat 1 "Provided Key is Wrong"
    fi 
fi 




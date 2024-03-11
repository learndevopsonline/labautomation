#!/bin/bash

curl -s https://raw.githubusercontent.com/learndevopsonline/scripts/master/common-functions.sh >/tmp/common-functions.sh
source /tmp/common-functions.sh

CheckRoot

CheckOS 7

which gcloud &>/dev/null
Stat $? "Checking Google Cloud CLI"
yum install dos2unix -y &>/dev/null

HNAME=$(hostname)
gcloud compute instances list 2>/dev/null| grep $HNAME &>/dev/null
if [ $? -ne 0 ]; then 
    PrintCenter "Please Open the coming URL, to create the and setup the LAB. Open the URL, and get the code and Paste it here"
    echo -e "\e[33m"
    gcloud auth login --quiet --brief
    gcloud compute instances list | grep $HNAME &>/dev/null
    if [ $? -ne 0 ]; then 
        Stat 1 "Provided Key is Wrong"
    fi 
fi 

PROJECT=$(gcloud config list --format 'value(core.project)')
IMAGE=$(gcloud compute images list | grep centos-7 | awk '{print $1}')

gcloud compute images list | grep mycentos7 &>/dev/null 
if [ $? -ne 0 ]; then 

    info "Checking Pre-requisites"
    gcloud compute instances list 2>/dev/null | grep imaging &>/dev/null
    if [ $? -eq 0 ]; then 
        zone=$(gcloud compute instances list | grep imaging | awk '{print $2}')
        gcloud compute instances delete imaging --quiet --zone $zone &>/dev/null 
        sleep 60
    fi

    gcloud compute instances create imaging --zone=us-east1-b --machine-type=n1-standard-1 --metadata=startup-script=curl\ -s\ https://raw.githubusercontent.com/learndevopsonline/scripts/master/init.sh\ \|\ sudo\ bash --image=$IMAGE --image-project=centos-cloud --boot-disk-size=10GB &>/dev/null
    Stat $? "Started making Image"


    while true ; do 
    a=1
    for i in \| \/ \- \\ \| \/ \- \\ ; do 
        [ $a -gt 8 ] && break
        (echo -n > /dev/tcp/imaging/22 ) &>/dev/null
        [ $? -eq 0 ] && A=0 && break 2
        echo -en "Waiting for SSH Connection .. $i \r"
        sleep 0.25
        a=$(($a+1))
    done
    done

    gcloud compute instances stop imaging --quiet &>/dev/null
    gcloud compute images create mycentos7 --source-disk=imaging --source-disk-zone us-east1-b &>/dev/null
    Stat $? "Creating CentOS 7 Image"

    gcloud compute instances delete imaging --quiet --zone $zone &>/dev/null 
    sleep 60

fi

ZONES=(us-east4-c us-central1-c us-west1-b europe-west1-b asia-east1-b asia-northeast1-b)
for servername in `curl -s https://raw.githubusercontent.com/learndevopsonline/labautomation/master/serverslist | dos2unix ` ; do
   echo -e "Creating Server .. $servername"
   RNO=$(( ( RANDOM % 6 )  + 1 ))
   zone=${ZONES[$RNO]}
   gcloud compute instances create $servername --zone=$zone --machine-type=n1-standard-1 --image=mycentos7 --image-project=$PROJECT --boot-disk-size=10GB &>/dev/null
   gcloud compute instances stop $servername --quiet --zone=$zone --async &>/dev/null
done

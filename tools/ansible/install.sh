#!/bin/bash 

source /tmp/common-functions.sh

if [ "$ELV" == "el7" ]; then
  yum install python3-pip -y
  pip3 install pip --upgrade
  pip3 install ansible
elif [ "$ELV" == "el8" ]; then
  yum install python3.11-devel python3.11-pip -y
  pip3.11 install ansible botocore boto3 python-jenkins
elif [ "$ELV" == "el9" ]; then
  yum install python3.11-devel python3.11-pip -y
  pip3.11 install ansible botocore boto3 python-jenkins
fi

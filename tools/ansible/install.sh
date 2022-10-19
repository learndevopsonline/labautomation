#!/bin/bash 

source /tmp/common-functions.sh

if [ "$ELV" == "el7" ]; then
  yum install python3-pip -y
  pip3 install pip --upgrade
  pip3 install ansible
elif [ "$ELV" == "el8" ]; then
  yum install python39-devel -y
  pip3.9 install ansible botocore boto3
fi

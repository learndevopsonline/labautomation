#!/bin/bash 

if [ -z "$CERT_NAME" ]; then 
  echo "Certificate Name is missing, export CERT_NAME and run again!!"
  exit 1
fi 

curl -s https://raw.githubusercontent.com/linuxautomations/nexus/master/install.sh | sudo bash 
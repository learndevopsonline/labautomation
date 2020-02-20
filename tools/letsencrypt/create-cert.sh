#!/bin/bash 

if [ -z "$CERT_NAME" ]; then 
  echo "Certificate Name is missing, export CERT_NAME and run again!!"
  exit 1
fi 

cd /tmp
git clone https://github.com/certbot/certbot.git 
cd certbot 
./letsencrypt-auto 
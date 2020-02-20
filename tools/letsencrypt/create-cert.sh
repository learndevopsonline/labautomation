#!/bin/bash 

if [ -z "$CERT_NAME" ]; then 
  echo "Certificate Name is missing, export CERT_NAME and run again!!"
  exit 1
fi 

DOMAIN_EMAIL=$(echo $CERT_NAME | awk -F . '{print "admin@"$2"."$3}')

if [ "$(curl ifconfig.co)" != "$(host )" ]

cd /tmp
git clone https://github.com/certbot/certbot.git 
cd certbot 
./letsencrypt-auto --help &>>/tmp/cert.log 
./letsencrypt-auto certonly --nginx -n --agree-tos -m $DOMAIN_EMAIL -d $CERT_NAME
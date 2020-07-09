#!/bin/bash 

if [ -z "$CERT_NAME" ]; then 
  echo "Certificate Name is missing, export CERT_NAME and run again!!"
  exit 1
fi 

DOMAIN_EMAIL=$(echo $CERT_NAME | awk -F . '{print "admin@"$2"."$3}')

if [ "$(curl ifconfig.co)" != "$(host $CERT_NAME | awk '{print $NF}')" ]; then 
  echo "DNS Entry is not matching the current server. Check again"
  echo DNS_ENTRY = $(host $CERT_NAME)
  echo SERVER_IP = $(curl ifconfig.co)
  exit 2
fi 

yum install nginx -y &>/dev/null 
systemctl enable nginx && systemctl start nginx 
if [ $? -ne 0 ]; then 
  echo "Install Nginx Failure "
  exit 1
fi 

cd /tmp
git clone https://github.com/certbot/certbot.git 
cd certbot 
./letsencrypt-auto --help &>>/tmp/cert.log 
./letsencrypt-auto certonly --nginx -n --agree-tos -m $DOMAIN_EMAIL -d $CERT_NAME

cp /etc/letsencrypt/live/$CERT_NAME/fullchain.pem /etc/nginx/server.crt 
cp /etc/letsencrypt/live/$CERT_NAME/privkey.pem /etc/nginx/server.key

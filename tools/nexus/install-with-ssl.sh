#!/bin/bash 

if [ -z "$CERT_NAME" ]; then 
  echo "Certificate Name is missing, export CERT_NAME and run again!!"
  exit 1
fi 

curl -s https://raw.githubusercontent.com/linuxautomations/nexus/master/install.sh | sudo bash 
curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/letsencrypt/install.sh | bash 

curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/nexus/nexus.conf >/etc/nginx/conf.d/nexus.conf 
sed -i -e "s/DOMAIN_NAME/${CERT_NAME}/" /etc/nginx/conf.d/nexus.conf 
systemctl restart nginx 

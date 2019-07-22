#!/bin/bash 

set -e 

if [ $(id -u) -ne 0 ]; then 
  echo -e "You should run this script as root user or sudo user"
  exit 1
fi 

URL=$(curl -s https://nodejs.org/en/download/ | grep tar | grep linux-x64 | sed -e 's/"/\n/g' | grep ^https)
FILENAME=$(echo $URL | awk -F / '{print $NF}')
FOLDER_NAME=$(echo $FILENAME |sed -e 's/.tar.xz//')

curl -s -o /tmp/$FILENAME $URL 
cd /opt
tar -xf /tmp/$FILENAME
mv $FOLDER_NAME nodejs
echo 'export PATH=$PATH:/opt/nodejs/bin' >>/etc/profile

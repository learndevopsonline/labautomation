#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "You need to run this as root user"
  exit 1
fi

docker ps &>/dev/null
if [ $? -ne 0 ]; then
  curl -s -L https://get.docker.com | bash &>/dev/null
  systemctl enable docker
  systemctl start docker
fi


read -p 'Enter Frontend IP Address: ' ip
read -p 'Enter Number of Clients: ' clients
read -p 'Enter Howmuch time to run[10m|1hr]: ' time

docker run -e "HOST=http://${ip}/" -e "NUM_CLIENTS=${clients}" -e "RUN_TIME=${time}" -e "ERROR=0" -e "SILENT=1" robotshop/rs-load

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


if [ -f /tmp/old-run-ip ]; then
  read -p "Enter Frontend IP Address [$(cat /tmp/old-run-ip)] : " ip
else
  read -p "Enter Frontend IP Address : " ip
fi
echo $ip >/tmp/old-run-ip
read -p 'Enter Number of Clients: ' clients
echo ${clients} >>/tmp/old-run-clients
read -p 'Enter Howmuch time to run[10m|1hr]: ' time
echo $time >>/tmp/old-run-time

nc -w 3 -z ${ip} 443
if [ $? -eq 0 ]; then
  URL="https://${ip}/"
else
  URL="http://${ip}/"
fi

docker run -e "HOST=${URL}" -e "NUM_CLIENTS=${clients}" -e "RUN_TIME=${time}" -e "ERROR=0" -e "SILENT=1" robotshop/rs-load

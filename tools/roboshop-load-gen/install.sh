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
  if [ -z "$ip" ]; then
    ip=$(cat /tmp/old-run-ip)
  fi
else
  read -p "Enter Frontend IP Address : " ip
fi

echo $ip >/tmp/old-run-ip

if [ -f /tmp/old-run-clients ]; then
  read -p "Enter Number of Clients [$(cat /tmp/old-run-clients)] : " clients
  if [ -z "$clients" ]; then
    ip=$(cat /tmp/old-run-clients)
  fi
else
  read -p 'Enter Number of Clients: ' clients
fi
echo ${clients} >>/tmp/old-run-clients

if [ -f /tmp/old-run-time ]; then
  read -p "Enter Howmuch time to run[10m|1hr] [$(cat /tmp/old-run-time)] : " time
  if [ -z "$time" ]; then
    ip=$(cat /tmp/old-run-time)
  fi
else
  read -p 'Enter Howmuch time to run[10m|1hr]: ' time
fi
echo ${time} >>/tmp/old-run-time

nc -w 3 -z ${ip} 443
if [ $? -eq 0 ]; then
  URL="https://${ip}/"
else
  URL="http://${ip}/"
fi

docker run -e "HOST=${URL}" -e "NUM_CLIENTS=${clients}" -e "RUN_TIME=${time}" -e "ERROR=0" -e "SILENT=1" robotshop/rs-load

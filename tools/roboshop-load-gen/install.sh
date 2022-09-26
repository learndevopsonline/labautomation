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

input=$(cat /tmp/old-run-ip 2>/dev/null)
if [ -z "${input}" ]; then
  message="Enter Frontend IP Address: "
else
  message="Enter Frontend IP Address [$input]: "
fi

read -p "${message}" ip
if [ -z "$ip" ]; then
  ip=$(cat /tmp/old-run-ip)
fi
echo $ip >/tmp/old-run-ip


input=$(cat /tmp/old-run-clients 2>/dev/null)
if [ -z "${input}" ]; then
  message="Enter number of Clients: "
else
  message="Enter number of Clients [$input]: "
fi

read -p "${message}" clients
if [ -z "$clients" ]; then
  clients=$(cat /tmp/old-run-clients)
fi
echo $clients >/tmp/old-run-clients


input=$(cat /tmp/old-run-time 2>/dev/null)
if [ -z "${input}" ]; then
  message="Enter time [10m|1hr]: "
else
  message="Enter time [10m|1hr] [$input]: "
fi

read -p "${message}" time
if [ -z "$time" ]; then
  time=$(cat /tmp/old-run-time)
fi
echo $time >/tmp/old-run-time


nc -w 3 -z ${ip} 443
if [ $? -eq 0 ]; then
  URL="https://${ip}/"
else
  URL="http://${ip}/"
fi

docker run -e "HOST=${URL}" -e "NUM_CLIENTS=${clients}" -e "RUN_TIME=${time}" -e "ERROR=0" -e "SILENT=1" robotshop/rs-load

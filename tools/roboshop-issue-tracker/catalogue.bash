#!/bin/bash

source /tmp/functions
#
echo -e "Restarting Catalogue"
systemctl restart catalogue
STAT "Restart Catalogue"
sleep 5

echo -e "Checking MongoDB Status"
curl -s localhost:8080/health | jq .mongo
DBSTAT=$(curl -s localhost:8080/health | jq .mongo)
if [ "${DBSTAT}" == "true" ]; then
  wB "Catalogue Connecting to MongoDB is \e[32mSUCCESS"
else
  wB "Catalogue Connecting to MongoDB is \e[31mFAILURE"
fi

DLIM
wB "Checking MongoDB"
DLIM1

echo "Finding IP address from Catalogue Config"
IP=$(cat /etc/systemd/system/catalogue.service  | grep MONGO_URL  | awk -F '[:,/]' '{print $4}')
wB "IP = $IP"
DBPORT=27107
CHECK_CONNECTION


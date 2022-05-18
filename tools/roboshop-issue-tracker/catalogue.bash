#!/bin/bash

curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/roboshop-issue-tracker/functions >/tmp/functions
source /tmp/functions

echo -e "Restarting Catalogue"
systemctl restart catalogue
STAT "Restart Catalogue"

echo -e "Checking MongoDB Status"
DBSTAT=$(curl -s localhost:8080/health | jq .mongo)
if [ $DBSTAT == "true" ]; then
  wB "Connection to MongoDB is \e[32mSUCCESS"
else
  wB "Connection to MongoDB is \e[32mFAILURE"
fi

DLIM
echo -e "\e[1m Checking MongoDB \e[0m"
DLIM1


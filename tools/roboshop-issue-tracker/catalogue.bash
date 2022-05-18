#!/bin/bash

source /tmp/functions

echo -e "Restarting Catalogue"
systemctl restart catalogue
STAT "Restart Catalogue"

echo -e "Checking MongoDB Status"

ps -ef
curl localhost:8080/health | jq .mongo
DBSTAT=`curl -s localhost:8080/health | jq .mongo`
if [ $DBSTAT == "true" ]; then
  wB "Catalogue Connecting to MongoDB is \e[32mSUCCESS"
else
  wB "Catalogue Connecting to MongoDB is \e[31mFAILURE"
fi

DLIM
wB "Checking MongoDB"
DLIM1


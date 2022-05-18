#!/bin/bash

echo -e "Restarting Catalogue"
systemctl restart catalogue
DBSTAT=$(curl -s localhost:8080/health | jq .mongo)
if [ $DBSTAT == "false" ]; then
  echo -e "Connection to MongoDB is FAILURE"
  echo "Finding MongoDB IP Address"
else
  echo -e "Connection to MongoDB is SUCCESS"
fi

DLIM
echo -e "\e[1m Checking MongoDB - \e[0m"
DLIM1


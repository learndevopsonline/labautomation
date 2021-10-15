#!/bin/bash

echo -e "This script runs only in FRONTEND, Hence if you are sure that you are \nrunning under frontend server then proceed.."
read -p 'Proceed [Y|n]: ' action
ACTION=$(echo $action| cut -c -1 | tr [a-z] [A-Z])
if [ "$ACTION" == "Y" ]; then
  if [ ! -f /etc/nginx/default.d/roboshop.conf ]; then
    echo -e "\e[1;33mUnable to find the Frontend Nginx Setup, Exiting.."
    exit 1
  fi
else
  exit
fi

#!/bin/bash 

if [ $(id -u) -eq 0 ]; then 
  echo "You should be a root user to perform this command"
  exit 1 
fi 

URL=$(curl -s https://www.sonarqube.org/downloads/ | grep 'Community Edition' | head -1  | xargs -n 1  | grep ^href | awk -F = '{print $2}')
curl 

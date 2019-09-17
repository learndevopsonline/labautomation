#!/bin/bash 

if [ $(id -u) -eq 0 ]; then 
  echo "You should be a root user to perform this command"
  exit 1 
fi 

URL=$(curl -s https://www.sonarqube.org/downloads/ | grep 'Community Edition' | head -1  | xargs -n 1  | grep ^href | awk -F = '{print $2}')
FILENAME=$(echo $URL | awk -F / '{print $NF}')
FOLDERNAME=$(echo $FILENAME | sed -e 's/.zip//g')

id sonar &>/dev/null 
if [ $? -ne 0]; then 
  useradd sonar 
fi 

cd /home/sonar 
pkill java 
rm -rf sonarqube 
curl -s -o $FILENAME $URL 
unzip $FILENAME 
rm -f $FILENAME
mv $FOLDERNAME 

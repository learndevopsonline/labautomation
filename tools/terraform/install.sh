#!/bin/bash 

URL=$(curl https://www.terraform.io/downloads.html  | grep 64-bit | grep linux_amd64.zip | awk -F \" '{print $2}')
FILE=$(echo $URL | awk -F / '{print $NF}')
curl -s -L -J -O $URL 
sudo yum install unzip -y 
unzip -o $FILE -d /bin
if [ $? -eq 0 ]; then 
  echo -e "\e[31m SUCCESS\e[0m"
fi 

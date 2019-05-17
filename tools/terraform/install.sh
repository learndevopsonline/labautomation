#!/bin/bash 

URL=$(curl https://www.terraform.io/downloads.html  | grep 64-bit | grep linux_amd64.zip | awk -F \" '{print $2}')
FILE=$(echo $URL | awk -F / '{print $NF}')
curl -s -L -J -O $URL 
unzip $FILE -d /bin

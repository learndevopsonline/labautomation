#!/bin/bash 

URL="https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip"
FILE=$(echo $URL | awk -F / '{print $NF}')
curl -s -L -J -O $URL 
sudo yum install unzip -y 
unzip $FILE -d /bin
if [ $? -eq 0 ]; then 
  echo -e "\e[31m SUCCESS\e[0m"
fi 

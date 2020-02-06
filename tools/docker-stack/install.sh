#!/bin/bash 

echo -e "\e[32m Installing Docker \e[0m"
curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/docker/install-docker-ce.sh | sudo bash 

echo -e "\e[32m Installing Docker Compose \e[0m"
curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/docker-compose/install.sh | sudo bash 

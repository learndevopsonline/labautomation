#!/bin/bash 

echo -e "\e[32m Installing Docker \e[0m"
curl -s https://raw.githubusercontent.com/learndevopsonline/labautomation/master/tools/docker/install-for-devops-trainings.sh | bash

echo -e "\e[32m Installing Docker Compose \e[0m"
curl -s https://raw.githubusercontent.com/learndevopsonline/labautomation/master/tools/docker-compose/install.sh | bash

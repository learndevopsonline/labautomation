#!/bin/bash 

curl -s https://raw.githubusercontent.com/linuxautomations/nexus/master/install.sh | sudo bash 

curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/letsencrypt/create-cert.sh | bash 
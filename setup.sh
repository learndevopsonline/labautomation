#!/bin/bash

echo -n -e "
1) Apache Web Server
2) Apache Tomcat
3) Apache Tomcat
4) Application Stack (WEB + APP + DB)
5) Exit 

Select an Option > "
read option

if [ $option -lt 1 -o $option -gt 5 ]; then 
  echo "Invalis Option. Try Again " 
  exit 1
fi

## Check SELINUX adn FIREWALL enabled or not.

### Install ansible

### Run Playbook
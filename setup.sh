#!/bin/bash

echo -n -e "
1) Apache Web Server
2) Apache Tomcat
3) MariaDB
4) Application Stack (WEB + APP + DB)
5) Gitlab
6) Maven
7) Jenkins
8) Ansible Tower
9) Docker
10) Kuburnetes Master 
11) Kuburnetes Node
E) Exit 

Select an Option > "
read option

if [ $option -lt 1 -o $option -gt 5 ]; then 
  echo "Invalid Option. Try Again " 
  exit 1
fi

if [ $option = 5 ]; then 
	exit 
fi

## Importing required source files.
curl -s https://raw.githubusercontent.com/linuxautomations/scripts/master/common-functions.sh >/tmp/common-functions.sh
source /tmp/common-functions.sh
## Supported OS's
# CentOS 7
if [ ! -f /etc/centos-release ]; then 
	error "Curently this setup works only for CentOS Operating System"
	exit 1
fi

EL=$(rpm -q basesystem | sed -e 's/\./ /g' |xargs -n1 | grep el)
if [ "$EL" != "el7" ]; then 
	error "Currently this setup works only for CentOS-7 OS"
	exit 1
fi

## Check SELINUX and FIREWALL enabled or not.
SESTATUS=$(sestatus|head -1 |awk '{print $NF}')
if [ "$SESTATUS" = 'enabled' ]; then 
	hint "SELINUX and FIREWALL enabled on Server.. Proceeding to disable them and it will  reboot the server"
	curl -s https://raw.githubusercontent.com/linuxautomations/scripts/master/init.sh | bash
fi

### Install ansible
yum install ansible -y &>/dev/null 

### Run Playbook
ansible-playbook playbooks/${option}.yml

## One more line

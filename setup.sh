#!/bin/bash

curl -s "https://raw.githubusercontent.com/linuxautomations/scripts/master/common-functions.sh" >/tmp/common-functions.sh
#source /root/scripts/common-functions.sh
source /tmp/common-functions.sh
## Checking Root User or not.
CheckRoot

## Checking SELINUX Enabled or not.
CheckSELinux

## Checking Firewall on the Server.
CheckFirewall

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
${R}E) Exit ${N}

Select an Option > "
read option

C=$(echo $option | cut -c 1)
[ "$C" -eq 1 ] &>/dev/null
STAT=$?
if [ $STAT -eq 2 ]; then 
	if [ "$option" = E ]; then 
		exit
	else
		error "Invalid Option. Try Again " 
		exit 1
	fi
else
	if [ $option -lt 1 -o $option -gt 11 ]; then 
	  error "Invalid Option. Try Again " 
	  exit 1
	fi
fi

### Install ansible
yum install ansible -y &>/dev/null 

### Run Playbook
ansible-playbook playbooks/${option}.yml

## One more line

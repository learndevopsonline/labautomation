#!/bin/bash 

if [ $(id -u) -ne 0 ]; then 
  echo "Run as root user"
  exit 1
fi 

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io -y

## Group add 
id centos &>/dev/null
if [ $? -eq 0 ]; then 
  groupadd -g 3000 docker &>/dev/null
  usermod -a -G docker centos
fi

systemctl enable docker 
systemctl start docker

echo -e "\e[33m \n\t --> You need to relogin and run the following command <-- \e[0m"
echo -e "    docker ps    "

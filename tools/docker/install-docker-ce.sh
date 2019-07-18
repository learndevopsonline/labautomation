#!/bin/bash 

if [ $(id -u) -ne 0 ]; then 
  echo "Run as root user"
  exit 1
fi 

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io -y
systemctl enable docker 
systemctl start docker

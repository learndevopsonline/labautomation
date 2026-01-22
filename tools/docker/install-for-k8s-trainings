#!/bin/bash

USERNAME=$USER
groupadd docker
usermod -a -G docker $USERNAME 
yum install docker -y 
systemctl enable docker
sed -i -e '/ExecStart/ c ExecStart=/usr/bin/dockerd-current -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock \\' /lib/systemd/system/docker.service
systemctl daemon-reload
systemctl start docker 
sudo su - $USERNAME 

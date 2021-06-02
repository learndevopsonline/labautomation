#!/bin/bash

yum install -y yum-utils
echo '[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://download.docker.com/linux/centos/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/centos/gpg

[extras]
name=CentOS-$releasever - Extras
baseurl=http://mirror.centos.org/centos/7/extras/x86_64/
enabled=1
gpgcheck=0' >/etc/yum.repos.d/docker.repo

yum install docker-ce docker-ce-cli containerd.io -y

systemctl enable docker
systemctl start docker


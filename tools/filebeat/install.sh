#!/bin/bash

rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

echo '[elastic-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md' >/etc/repos.d/filebeat.repo

Print "Installing Filebeat"
yum install filebeat -y &>>/tmp/lab.log
STAT $?

Print "Starting Filebeat"
systemctl start filebeat && systemctl enable filebeat
STAT $?



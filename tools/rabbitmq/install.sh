#!/bin/bash 

source /tmp/labautomation/dry/common-functions.sh

yum install https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_22.2.1-1~centos~7_amd64.rpm -y 

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash

yum install rabbitmq-server -y 
systemctl enable rabbitmq-server 
systemctl start rabbitmq-server 

Stat 0 "Starting RabbitMQ Service"

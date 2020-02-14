#!/bin/bash 



yum install epel-release yum-utils
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi


sudo yum install redis


sudo systemctl start redis
sudo systemctl enable redis
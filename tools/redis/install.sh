#!/bin/bash 



yum install epel-release yum-utils
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi
Install the Redis package by typing:

sudo yum install redis
Once the installation is completed, start the Redis service and enable it to start automatically on boot with:

sudo systemctl start redis
sudo systemctl enable redis
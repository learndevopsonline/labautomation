#!/bin/bash 

yum install epel-release yum-utils -y
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum-config-manager --enable remi
yum install redis -y


systemctl start redis
systemctl enable redis
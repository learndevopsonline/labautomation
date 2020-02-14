#!/bin/bash 



yum install epel-release yum-utils
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi
yum install redis -y


systemctl start redis
systemctl enable redis
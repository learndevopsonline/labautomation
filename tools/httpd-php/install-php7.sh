#!/bin/bash 

yum install httpd -y 
yum install  http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y 
yum -y install yum-utils

yum-config-manager --enable remi-php70
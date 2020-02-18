#!/bin/bash 

yum install httpd -y 
yum install  http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y 
yum -y install yum-utils

yum-config-manager --enable remi-php73
yum -y install php php-opcache php73-php-pdo composer

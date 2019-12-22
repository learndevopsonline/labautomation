#!/bin/bash 

curl -s "https://raw.githubusercontent.com/linuxautomations/scripts/master/common-functions.sh" >/tmp/common-functions.sh
#source /root/scripts/common-functions.sh
source /tmp/common-functions.sh 


CheckRoot 

echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb-org-4.2.repo 

yum install -y mongodb-org
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

systemctl start mongod 
systemctl enable mongod


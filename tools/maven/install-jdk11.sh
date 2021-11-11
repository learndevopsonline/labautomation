#!/bin/bash

if [ $(id -u) -ne 0 ]; then 
  echo "You should be a root user / sudo user to perform this script"
  exit 1
fi 

yum install java-1.8.0-openjdk-devel unzip  -y

VERSION=$(curl -s https://maven.apache.org/download.cgi  | grep Downloading |awk '{print $NF}' |awk -F '<' '{print $1}')
cd /opt
curl -s https://archive.apache.org/dist/maven/maven-3/${VERSION}/binaries/apache-maven-${VERSION}-bin.zip -o /tmp/apache-maven-${VERSION}-bin.zip
unzip /tmp/apache-maven-${VERSION}-bin.zip
mv apache-maven-${VERSION} maven
ln -s /opt/maven/bin/mvn /bin/mvn

#

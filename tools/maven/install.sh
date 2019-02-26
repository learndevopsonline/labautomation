#!/bin/bash

VERSION=$(curl -s https://maven.apache.org/download.cgi  | grep Downloading |awk '{print $NF}' |awk -F '<' '{print $1}')
cd /opt
curl -s https://archive.apache.org/dist/maven/maven-3/${VERSION}/binaries/apache-maven-${VERSION}-bin.zip -o /tmp/apache-maven-${VERSION}-bin.zip
unzip /tmp/apache-maven-${VERSION}-bin.zip

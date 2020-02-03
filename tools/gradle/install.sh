#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "You should be a root user / sudo user to perform this script"
  exit 1
fi

yum install java-1.8.0-openjdk-devel unzip  -y

rm -rf /opt/gradle
DOWNLOAD_URL=$(curl -s https://gradle.org/releases/  | grep bin.zip | head -1 |xargs -n1 | grep ^href | awk -F = '{print $2}')
DIR_NAME=$(echo $DOWNLOAD_URL | awk -F / '{print $NF}' | sed -e 's/-bin.zip//')
cd /opt
curl -L -o /opt/gradle.zip $DOWNLOAD_URL
unzip gradle.zip
mv $DIR_NAME gradle
ln -s /opt/gradle/bin/gradle /bin/gradle
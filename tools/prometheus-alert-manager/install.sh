#!/bin/bash

if [ $(id -u) -ne 0 ]; then 
  echo "You should run as root user"
  exit 1
fi 

if [ -d /opt/alertmanager ]; then
  exit 0
fi 

URL=$(curl -L -s https://prometheus.io/download/  | grep tar | grep alertmanager- | grep linux-amd64  | sed -e "s|>| |g" -e 's|<| |g' -e 's|"| |g' |xargs -n1 | grep ^http | tail -1)

FILENAME=$(echo $URL | awk -F / '{print $NF}')
DIRNAME=$(echo $FILENAME | sed -e 's/.tar.gz//')

cd /opt
curl -s -L -O $URL 
tar -xf $FILENAME 
rm -f $FILENAME 
mv $DIRNAME alertmanager

curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/prometheus-alert-manager/alertmanager.service >/etc/systemd/system/alertmanager.service
systemctl enable alertmanager
systemctl start alertmanager

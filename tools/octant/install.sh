#!/bin/bash 

yum install https://github.com/vmware-archive/octant/releases/download/v0.25.1/octant_0.25.1_Linux-64bit.rpm -y
rpm -qa | grep minikube &>/dev/null
if [ $? -eq 0 ]; then
  cp /tmp/labautomation/tools/octant/octant-minikube.service /etc/systemd/system/octant.service
else
  id centos &>/dev/null
  if [ $? -eq 0 ]; then
    sed -e "s/USER/centos/" /tmp/labautomation/tools/octant/octant.service >/etc/systemd/system/octant.service
  else
    sed -e "s/USER/ec2-user/" /tmp/labautomation/tools/octant/octant.service >/etc/systemd/system/octant.service
  fi
fi
systemctl daemon-reload
systemctl enable octant
systemctl restart octant


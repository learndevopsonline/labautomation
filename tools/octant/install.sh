#!/bin/bash 

yum install https://github.com/vmware-archive/octant/releases/download/v0.25.1/octant_0.25.1_Linux-64bit.rpm
curl -s https://raw.githubusercontent.com/learndevopsonline/labautomation/master/tools/octant/octant.service >/etc/systemd/system/octant.service
systemctl enable octant
systemctl start octant


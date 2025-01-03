#!/bin/bash 

#source ../$(pwd  | awk -F 'labautomation/' '{print $2}')/dry/common-functions.sh
if [ -f dry/common-functions.sh ]; then
  source dry/common-functions.sh
fi

source /tmp/labautomation/dry/common-functions.sh
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

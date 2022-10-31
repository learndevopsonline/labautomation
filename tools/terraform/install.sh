#!/bin/bash 

#source ../$(pwd  | awk -F 'labautomation/' '{print $2}')/dry/common-functions.sh
if [ -f dry/common-functions.sh ]; then
  source dry/common-functions.sh
fi

curl -s -L https://raw.githubusercontent.com/linuxautomations/labautomation/master/dry/common-functions.sh >/tmp/common-functions.sh
source /tmp/common-functions.sh
yum install -y yum-utils
case $OSVENDOR in
  CentOS)
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
  ;;
  "Amazon Linux")
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
  ;;
  *)
    echo "OS not Supproted"
    exit 1
esac
yum -y install terraform

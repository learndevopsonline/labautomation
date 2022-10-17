#!/bin/bash 

yum install -y yum-utils
case $OSVENDOR in
  CentOS)
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
  ;;
  Amazon Linux)
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
  ;;
  *)
    echo "OS not Supproted"
    exit 1
esac
yum -y install terraform

#!/bin/bash

if [ $(id -u) -ne 0 ]; then
    echo -e "You should run this script as root user"
    exit 1
fi

echo '
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg' >/etc/yum.repos.d/gcloud.repo

yum install google-cloud-sdk -y

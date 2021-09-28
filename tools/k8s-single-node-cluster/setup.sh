#!/bin/bash

read -p 'Enter DNS Hosted Zone Name: ' hname
export TF_VAR_HOSTED_ZONE=${hname}

if [ ! -f "~/.ssh/id_rsa.pub" ]; then
  cat /dev/zero | ssh-keygen -q -N ""
fi

mkdir -p ~/.kube
curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/terraform/install.sh | sudo bash
curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/k8-client-stack/install.sh | sudo bash
rm -rf .terraform*
terraform init
terraform apply -auto-approve

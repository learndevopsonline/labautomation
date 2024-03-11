#!/bin/bash


pwd

read -p 'Enter DNS Hosted Zone Name: ' hname
export TF_VAR_HOSTED_ZONE=${hname}

if [ ! -f "~/.ssh/id_rsa.pub" ]; then
  cat /dev/zero | ssh-keygen -q -N ""
fi

mkdir -p ~/.kube
curl -s https://raw.githubusercontent.com/learndevopsonline/labautomation/master/tools/terraform/install.sh | bash
curl -s https://raw.githubusercontent.com/learndevopsonline/labautomation/master/tools/k8-client-stack/install.sh | bash
rm -rf .terraform*
cd /tmp/labautomation/tools/k8s-single-node-cluster
terraform init
terraform apply -auto-approve

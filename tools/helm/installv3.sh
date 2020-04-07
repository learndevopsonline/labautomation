#!/bin/bash 

cd /tmp 
curl -L https://get.helm.sh/helm-$(curl -s https://github.com/helm/helm/releases  | grep muted-link | grep v3 | head -1 | awk '{print $NF}' | awk -F \" '{print $2}')-linux-amd64.tar.gz | tar -xz
sudo linux-amd64/helm /bin

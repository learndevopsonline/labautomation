#!/bin/bash 

cd /tmp 
#curl -L $(curl -L -s https://github.com/helm/helm/releases  | grep tar.gz | grep linux-amd64 | head -1 | sed -e 's|"| |g' | xargs -n1 | grep '.tar.gz$') | tar -xz
curl -L https://get.helm.sh/helm-v3.8.1-linux-amd64.tar.gz | tar -xz
mv linux-amd64/helm /usr/local/bin

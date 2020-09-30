#!/bin/bash 

VERSION=$(curl -s https://releases.hashicorp.com/packer/  | grep packer_ | head -1|sed -e 's|<| |g' -e 's|>| |g' | xargs -n1  | grep packer_ | sed -e 's/packer_//')

curl -s https://releases.hashicorp.com/packer/${VERSION}/packer_${VERSION}_linux_amd64.zip -o /tmp/packer.zip 
unlink /sbin/packer
cd /bin 
unzip -o /tmp/packer.zip 
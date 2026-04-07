#!/bin/bash

## Check Root User

if [ $(id -u) -ne 0 ]; then
  echo "You should be root user to perform this script"
  exit 1
fi

curl -L -o /bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x /bin/kubectl

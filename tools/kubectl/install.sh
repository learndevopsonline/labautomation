#!/bin/bash

## Check Root User

if [ $(id -u) -ne 0 ]; then
  echo "You should be root user to perform this script"
  exit 1
fi

curl -L https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl -o /bin/kubectl
chmod +x /bin/kubectl

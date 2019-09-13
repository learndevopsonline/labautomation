#!/bin/bash

if [ $(id -u) -ne 0  ]; then
  echo "You should run this script as root user"
  exit 1
fi

curl -sL https://git.io/get_helm.sh | bash 

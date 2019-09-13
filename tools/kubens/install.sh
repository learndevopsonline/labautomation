#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "You should be root user to perform this script"
  exit 1
fi

curl -s -o /bin/kubens https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens
chmod +x /bin/kubens

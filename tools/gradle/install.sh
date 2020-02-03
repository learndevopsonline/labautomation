#!/bin/bash 

if [ $(id -u) -ne 0 ]; then 
  echo "You should be a root user / sudo user to perform this script"
  exit 1
fi 

yum install java-1.8.0-openjdk-devel unzip  -y
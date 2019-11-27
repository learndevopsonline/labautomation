#!/bin/bash 

echo "Note: This script is made to run on Centos 7 OS.. Cannot gaurantee on other OS's"
sleep 5

LOG=/tmp/awx.log 

echo -e "Installing Python 3" 
yum install python
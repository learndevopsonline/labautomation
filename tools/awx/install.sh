#!/bin/bash 

Stat() {
  if [ $1 -ne 0 ]; then
    echo -e "\e[31m Installation Failed.. Refer Log file $LOG .."
    exit 1
  fi 
}

echo "Note: This script is made to run on Centos 7 OS.. Cannot gaurantee on other OS's"
sleep 5

LOG=/tmp/awx.log 
rm -f $LOG 

echo -e "Installing Python 3" 
yum install python36 python36-devel -y &>>$LOG 
Stat $?

echo -e ""
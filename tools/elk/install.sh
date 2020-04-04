#!/bin/bash 

Y="\e[33m"
N="\e[0m"

STAT() {
  if [ $1 -ne 0 ]; then 
    echo "\e[31mFAILED\e[0m"
    exit 1
  fi 
}

Print() {
  echo -e "${Y}${1}${N}"
}

## Install html2text 
Print "Installing Html2text"

yum install https://li.nux.ro/download/nux/dextop/el7/x86_64/html2text-1.3.2a-14.el7.nux.x86_64.rpm -y  &>/dev/null
STAT $?
VERSION=$(curl -s -L https://www.elastic.co/downloads/elasticsearch  | html2text  | grep Version -A 1 | tail -1)

Print "Installing Elasicsearch"

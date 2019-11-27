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

echo "Install Docker"
curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/docker/install-docker-ce.sh | bash 
Stat $?

echo "Install DOcker-Compose"
curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/docker-compose/install.sh | bash &>>$LOG
Stat $?

echo "Install NodeJS"
curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/nodejs/install.sh | bash &>>$LOG
Stat $?

echo "Install Ansible"
yum install ansible -y &>>$LOG 
Stat $?

echo -e "Install python modules"
pip3 install docker docker-compose &>>$LOG 
Stat $?

echo "Cloning AWX Repo"
git clone https://github.com/ansible/awx.git
cd awx/installer 
sed -i -e 's'
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

ln -s /usr/bin/python3 /usr/bin/python33 || true

echo "Install Docker"
curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/docker/install-docker-ce.sh | bash  &>>$LOG
Stat $?

echo "Install DOcker-Compose"
curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/docker-compose/install.sh | bash -x  #&>>$LOG
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

#docker pull ansible/awx_task:11.1.0
#docker tag  ansible/awx_task:11.1.0 ansible/awx_task:11.2.0

echo "Cloning AWX Repo"
git clone https://github.com/ansible/awx.git
cd awx
git checkout 17.1.0
cd installer 
sed -i -e '/^localhost/ c localhost ansible_connection=local ansible_python_interpreter="/usr/bin/env python3"' -e '/^admin_password/ c admin_password=password' -e '/^#\ admin_password/ c  admin_password=password' inventory
ansible-playbook -i inventory install.yml
if [ $? -eq 0 ]; then 
  echo "You can access the AWX using the following detials"
  echo "URL: http://$(curl ifconfig.co)/"
  echo "Username / Password : admin / password"
fi 

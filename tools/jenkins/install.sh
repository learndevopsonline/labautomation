#!/bin/bash 

if [ $(id -u) -ne 0 ]; then 
    echo -e "You should perform this as root user"
    exit 1
fi 
Stat() {
    if [ $1 -ne 0 ]; then 
        echo "Install Failed ::: Check log file /tmp/jinstall.log"
        exit 2 
    fi 
}

yum install java wget -y  &>/tmp/jinstall.log 
Stat $?
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo &>>/tmp/jinstall.log 
Stat $?

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key &>>/tmp/jinstall.log 
Stat $?

sudo yum install jenkins -y &>>/tmp/jinstall.log 
Stat $?

systemctl enable jenkins  &>>/tmp/jinstall.log 
Stat $?

systemctl start jenkins  &>>/tmp/jinstall.log 
Stat $?

echo -e "\e[32m INSTALLATION SUCCESSFUL\e[0m"

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

yum install fontconfig java-11-openjdk-devel wget -y  &>/tmp/jinstall.log
Stat $?
wget --no-check-certificate -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo &>>/tmp/jinstall.log 
Stat $?

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key &>>/tmp/jinstall.log 
Stat $?

yum install jenkins -y &>>/tmp/jinstall.log
Stat $?

systemctl enable jenkins  &>>/tmp/jinstall.log 
Stat $?

systemctl start jenkins  &>>/tmp/jinstall.log 
Stat $?

echo -e "\e[32m INSTALLATION SUCCESSFUL\e[0m"

mkdir -p /var/lib/jenkins/.ssh
echo 'Host *
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no' >/var/lib/jenkins/.ssh/config
chown jenkins:jenkins /var/lib/jenkins/.ssh -R
chmod 400 /var/lib/jenkins/.ssh/config

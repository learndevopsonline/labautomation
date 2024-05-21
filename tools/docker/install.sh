#!/bin/bash 

rpm -qi redhat-release &>/dev/null
if [ $? -eq 0 ]; then
  user=ec2-user
  yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
  yum install docker-ce --nobest -y
else
  curl -s https://get.docker.com | bash
  user=centos
fi

## Group add 
id $user &>/dev/null
if [ $? -eq 0 ]; then 
  groupadd docker &>/dev/null
  usermod -a -G docker $user
fi

systemctl enable docker 
systemctl start docker

echo -e "\e[33m \n\t --> You need to relogin and run the following command <-- \e[0m"
echo -e "    docker ps    "

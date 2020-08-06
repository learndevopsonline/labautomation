#!bin/bash 

yum remove mariadb-libs -y 

rpm -qa | grep mysql-community-server &>/dev/null 
if [ $? -eq 0 ]; then 
  echo "MySQL Install - Skipping"
  exit 0
fi
wget https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar 
tar -xf mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar 
yum install mysql-community-client-5.7.28-1.el7.x86_64.rpm mysql-community-devel-5.7.28-1.el7.x86_64.rpm mysql-community-common-5.7.28-1.el7.x86_64.rpm mysql-community-libs-5.7.28-1.el7.x86_64.rpm mysql-community-server-5.7.28-1.el7.x86_64.rpm -y 
if [ $? -eq 0 ]; then 
  rm -f mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar *.rpm 
else 
  echo -e "\e[31m Installation FAILED\e[0m"
  exit 1
fi 

systemctl start mysqld
sleep 20
echo "\n\e[33m Following is the root password :: "
cat /var/log/mysqld.log | grep password | tail -1 | awk '{print $NF}'

echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass@1';\nuninstall plugin validate_password;\nALTER USER 'root'@'localhost' IDENTIFIED BY 'password';" >/tmp/remove-plugin.sql 
mysql --connect-expired-password -uroot -p </tmp/remove-plugin.sql 
if [ $? -eq 0 ]; then 
  echo -e "MySQL password is successfully reset and the password of user 'root' now is 'password'"
fi

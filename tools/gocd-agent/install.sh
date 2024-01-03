source /tmp/labautomation/dry/common-functions.sh


curl https://download.gocd.org/gocd.repo -o /etc/yum.repos.d/gocd.repo  &>>/tmp/gocd-server.log
Stat $? "Download GoCD Repo File"

yum install -y go-agent &>>/tmp/gocd-server.log
Stat $? "Install GoCD Server"

echo -e "\e[35m Open file : /usr/share/go-agent/wrapper-config/wrapper-properties.conf"
echo -e "\e[35m Then Update GoCD Server IP Address"
echo -e "\e[36m Then Restart go-agent service (systemctl restart go-agent)\e[0m"




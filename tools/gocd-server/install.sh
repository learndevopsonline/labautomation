source /tmp/labautomation/dry/common-functions.sh


dnf install java-17-openjdk.x86_64 -y  &>/tmp/gocd-server.log
Stat $? "Install Java"

curl https://download.gocd.org/gocd.repo -o /etc/yum.repos.d/gocd.repo  &>>/tmp/gocd-server.log
Stat $? "Download GoCD Repo File"

yum install -y go-server &>>/tmp/gocd-server.log
Stat $? "Install GoCD Server"

systemctl restart go-server &>>/tmp/gocd-server.log
Stat $? "Start GoCD Service"

echo -e "Open this URL -> http://$(curl ifconfig.co):8153"

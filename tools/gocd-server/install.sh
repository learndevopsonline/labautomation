source /tmp/labautomation/dry/common-functions.sh

dnf install java-17-openjdk.x86_64 -y  &>/tmp/gocd-server.log
Stat $? "Install Java"

id gocd  &>>/tmp/gocd-server.log
if [ $? -ne 0 ]; then
useradd gocd  &>>/tmp/gocd-server.log
fi
Stat $? "Adding GoCD user"

curl -L -o /opt/go-server-23.5.0-18179.zip  https://download.gocd.org/binaries/23.5.0-18179/generic/go-server-23.5.0-18179.zip &>>/tmp/gocd-server.log
Stat $? "Download GoCD zip File"

unzip  -o /opt/go-server-23.5.0-18179.zip -d /home/gocd/ &>>/tmp/gocd-server.log
Stat $? "Unzipping GoCD zip file"

chown -R gocd:gocd /home/gocd/go-server-23.5.0  &>>/tmp/gocd-server.log
Stat $? "Changing Ownership of /home/gocd/go-server-23.5.0 directory"

echo '
[Unit]
Description=go-server
After=syslog.target

[Service]
Type=forking
User=gocd
ExecStart=/home/gocd/go-server-23.5.0/bin/go-server start sysd
ExecStop=/home/gocd/go-server-23.5.0/bin/go-server stop sysd
KillMode=control-group
Environment=SYSTEMD_KILLMODE_WARNING=true

[Install]
WantedBy=multi-user.target

' >/etc/systemd/system/go-server.service
Stat $? "Setup systemd GoCD Service file"

systemctl daemon-reload &>>/tmp/gocd-server.log
Stat $? "Load the Service"

systemctl enable go-server &>>/tmp/gocd-server.log
Stat $? "Enable GoCD Service"

systemctl start go-server &>>/tmp/gocd-server.log
Stat $? "Start GoCD Service"

echo -e "Open this URL -> http://$(curl -s ifconfig.me):8153"

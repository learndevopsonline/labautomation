source /tmp/labautomation/dry/common-functions.sh

dnf install java-17-openjdk.x86_64 -y  &>/tmp/gocd-agent.log
Stat $? "Install Java"

id gocd  &>>/tmp/gocd-agent.log
if [ $? -ne 0 ]; then
useradd gocd  &>>/tmp/gocd-agent.log
fi
Stat $? "Adding GoCD user"

curl -L -o /tmp/go-agent-23.5.0-18179.zip https://download.gocd.org/binaries/23.5.0-18179/generic/go-agent-23.5.0-18179.zip &>>/tmp/gocd-agent.log
Stat $? "Download GoCD zip File"

unzip  -o /tmp/go-agent-23.5.0-18179.zip -d /home/gocd/ &>>/tmp/gocd-agent.log && rm -f /tmp/go-agent-23.5.0-18179.zip
Stat $? "Unzipping GoCD zip file"

chown -R gocd:gocd /home/gocd/go-agent-23.5.0  &>>/tmp/gocd-agent.log


echo '
[Unit]
Description=GoCD Server

[Service]
Type=forking
User=gocd
ExecStart=/home/gocd/go-agent-23.5.0/bin/go-agent start sysd
ExecStop=/home/gocd/go-agent-23.5.0/bin/go-agent stop sysd
KillMode=control-group
Environment=SYSTEMD_KILLMODE_WARNING=true

[Install]
WantedBy=multi-user.target

' >/etc/systemd/system/go-agent.service
Stat $? "Setup systemd GoCD Service file"

systemctl daemon-reload &>>/tmp/gocd-agent.log
Stat $? "Load the Service"

systemctl enable go-agent &>>/tmp/gocd-agent.log
Stat $? "Enable GoCD Service"

systemctl start go-agent &>>/tmp/gocd-agent.log
Stat $? "Start GoCD Service"

echo -e "Open this URL -> http://$(curl -s ifconfig.me):8153"

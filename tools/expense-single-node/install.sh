dnf module disable nodejs -y
dnf module enable nodejs:20 -y

dnf install nginx  mysql-server nodejs -y
systemctl enable mysqld
systemctl start mysqld
mysql_secure_installation --set-root-pass ExpenseApp@1

useradd expense
rm -rf /app && mkdir /app
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip
cd /app
unzip /tmp/backend.zip
cd /app
npm install

IPADDR=$(hostname -i)

echo '
[Unit]
Description = Backend Service

[Service]
User=expense
Environment=DB_HOST="MYSQL-SERVER-IPADDRESS"
ExecStart=/bin/node /app/index.js
SyslogIdentifier=backend

[Install]
WantedBy=multi-user.target
' | sed -e "s|MYSQL-SERVER-IPADDRESS|${IPADDR}|" > /etc/systemd/system/backend.service
systemctl daemon-reload
systemctl enable backend
systemctl restart backend
mysql -h ${IPADDR} -uroot -pExpenseApp@1 < /app/schema/backend.sql




rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo '
proxy_http_version 1.1;

location /api/ { proxy_pass http://localhost:8080/; }

location /health {
  stub_status on;
  access_log off;
}
' >/etc/nginx/default.d/expense.conf

systemctl enable nginx
systemctl restart nginx


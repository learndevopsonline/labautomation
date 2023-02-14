#!/bin/bash

echo '
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=0
enabled=1

[mysql]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0

' >/etc/yum.repos.d/db.repo

yum install mongodb-org -y



systemctl enable mongod
systemctl start mongod

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

dnf module enable redis:remi-6.2 -y
yum install redis -y

systemctl enable redis
systemctl start redis

dnf module disable mysql -y
yum install mysql-community-server -y

systemctl enable mysqld
systemctl start mysqld

mysql_secure_installation --set-root-pass RoboShop@1

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash

yum install erlang -y
yum install rabbitmq-server -y

systemctl enable rabbitmq-server
systemctl start rabbitmq-server

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

useradd roboshop
curl -sL https://rpm.nodesource.com/setup_lts.x | bash


yum install python36 gcc python3-devel golang maven nodejs -y

mkdir -p /dispatch
cd /dispatch
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
unzip -o /tmp/dispatch.zip

go mod init dispatch
go get
go build

echo '
[Unit]
Description = Dispatch Service
[Service]
User=roboshop
Environment=AMQP_HOST=localhost
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123
ExecStart=/dispatch/dispatch
SyslogIdentifier=dispatch

[Install]
WantedBy=multi-user.target
' >/etc/systemd/system/dispatch.service


systemctl daemon-reload

systemctl enable dispatch
systemctl start dispatch


mkdir /payment
cd /payment

curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
unzip -o /tmp/payment.zip
pip3.6 install -r requirements.txt

echo '
[Unit]
Description=Payment Service

[Service]
User=root
WorkingDirectory=/payment
Environment=CART_HOST=localhost
Environment=CART_PORT=8082
Environment=USER_HOST=localhost
Environment=USER_PORT=8083
Environment=AMQP_HOST=localhost
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123
Environment=SHOP_PAYMENT_PORT=8084

ExecStart=/usr/local/bin/uwsgi --ini payment.ini
ExecStop=/bin/kill -9 $MAINPID
SyslogIdentifier=payment

[Install]
WantedBy=multi-user.target
' >/etc/systemd/system/payment.service

sed -i -e 's/8080/8084/' /payment/payment.ini

systemctl daemon-reload
systemctl enable payment
systemctl start payment

mkdir -p /shipping
cd /shipping

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
unzip -o /tmp/shipping.zip
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo '
[Unit]
Description=Shipping Service

[Service]
User=roboshop
Environment=CART_ENDPOINT=localhost:8082
Environment=DB_HOST=localhost
ExecStart=/bin/java -jar /shipping/shipping.jar
SyslogIdentifier=shipping

[Install]
WantedBy=multi-user.target

' >/etc/systemd/system/shipping.service


systemctl daemon-reload
systemctl enable shipping
systemctl start shipping
mysql -h localhost  -uroot -pRoboShop@1 < /shipping/schema/shipping.sql

mkdir -p /cart /user /catalogue

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

cd /cart
unzip -o /tmp/cart.zip

cd /user
unzip -o /tmp/user.zip

cd /catalogue
unzip -o /tmp/catalogue.zip

for i in cart catalogue user ; do
  cd /$i
  npm install
done

echo '
[Unit]
Description = Cart Service
[Service]
User=roboshop
Environment=CART_SERVER_PORT=8082
Environment=REDIS_HOST=127.0.0.1
Environment=CATALOGUE_HOST=127.0.0.1
Environment=CATALOGUE_PORT=8081
ExecStart=/bin/node /cart/server.js
SyslogIdentifier=cart

[Install]
WantedBy=multi-user.target

' >/etc/systemd/system/cart.service

echo '
[Unit]
Description = User Service
[Service]
User=roboshop
Environment=MONGO=true
Environment=REDIS_HOST=127.0.0.1
Environment=USER_SERVER_PORT=8083
Environment=MONGO_URL="mongodb://127.0.0.1:27017/users"
ExecStart=/bin/node /user/server.js
SyslogIdentifier=user

[Install]
WantedBy=multi-user.target

' >/etc/systemd/system/user.service

echo '
[Unit]
Description = Catalogue Service

[Service]
User=roboshop
Environment=MONGO=true
Environment=CATALOGUE_SERVER_PORT=8081
Environment=MONGO_URL="mongodb://127.0.0.1:27017/catalogue"
ExecStart=/bin/node /catalogue/server.js
SyslogIdentifier=catalogue

[Install]
WantedBy=multi-user.target

' >/etc/systemd/system/catalogue.service

systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue
systemctl enable cart
systemctl start cart
systemctl enable user
systemctl start user

mongo --host 127.0.0.1 </catalogue/schema/catalogue.js
mongo --host 127.0.0.1 </user/schema/user.js

yum install nginx -y
rm -rf /usr/share/nginx/html/*

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo '
proxy_http_version 1.1;
location /images/ {
  expires 5s;
  root   /usr/share/nginx/html;
  try_files $uri /images/placeholder.jpg;
}
location /api/catalogue/ { proxy_pass http://127.0.0.1:8081/; }
location /api/user/ { proxy_pass http://127.0.0.1:8083/; }
location /api/cart/ { proxy_pass http://127.0.0.1:8082/; }
location /api/shipping/ { proxy_pass http://127.0.0.1:8080/; }
location /api/payment/ { proxy_pass http://127.0.0.1:8084/; }

location /health {
  stub_status on;
  access_log off;
}
' >/etc/nginx/default.d/roboshop.conf
systemctl restart nginx
systemctl enable nginx


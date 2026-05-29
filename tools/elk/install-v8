#!/bin/bash

source /tmp/labautomation/dry/common-functions.sh

echo '[elasticsearch]
name=Elasticsearch repository for 8.x packages
baseurl=https://artifacts.elastic.co/packages/8.x/yum
gpgcheck=0
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
' >/etc/yum.repos.d/elastic.repo

yum install elasticsearch -y | tee -a /opt/elastic.log


systemctl enable elasticsearch &>>/tmp/elastic.log
systemctl start elasticsearch &>>/tmp/elastic.log

yum install kibana -y &>>/tmp/elastic.log
Stat $? "Install Kibana"


systemctl enable kibana &>>/tmp/elastic.log
systemctl start kibana &>>/tmp/elastic.log
Stat $? "Start Kibana"

yum install logstash -y &>>/tmp/elastic.log
Stat $? "Install LogStash"

echo 'input {
  beats {
    port => 5044
  }
}

output {
  elasticsearch {
    hosts => ["https://localhost:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}"
    user => "elastic"
    password => "REPLACE-YOUR_PASSWORD"
    ssl_certificate_verification => false
  }
}' >/etc/logstash/conf.d/logstash.conf

systemctl enable logstash &>>/tmp/elastic.log
systemctl start logstash &>>/tmp/elastic.log
Stat $? "Start Logstash"

yum install nginx -y &>/dev/null
Stat $? "Install Nginx"


curl -s https://raw.githubusercontent.com/learndevopsonline/labautomation/master/tools/elk/http-proxy.conf >/etc/nginx/nginx.conf
systemctl enable nginx
systemctl start nginx
Stat $? "Start Kibana"


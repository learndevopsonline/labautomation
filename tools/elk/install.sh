#!/bin/bash 

curl -s "https://raw.githubusercontent.com/linuxautomations/scripts/master/common-functions.sh" >/tmp/common-functions.sh
#source /root/scripts/common-functions.sh
source /tmp/common-functions.sh

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

echo '[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md' > /etc/yum.repos.d/elastic.repo
Stat $? "Setup Yum Repo"

yum install --enablerepo=elasticsearch elasticsearch -y &>>/tmp/elastic.log
Stat $? "Install Elasticsearch"

IPADDR=$(hostname -i | awk '{print $NF}')
sed -i -e "/network.host/ c network.host: 0.0.0.0" -e "/http.port/ c http.port: 9200" -e "/cluster.initial_master_nodes/ c cluster.initial_master_nodes: \[\"${IPADDR}\"\]" /etc/elasticsearch/elasticsearch.yml

systemctl enable elasticsearch &>>/tmp/elastic.log
systemctl start elasticsearch &>>/tmp/elastic.log
Stat $? "Start Elasticsearch"

yum install kibana  --enablerepo=elasticsearch -y &>>/tmp/elastic.log
Stat $? "Install Kibana"

systemctl enable kibana &>>/tmp/elastic.log
systemctl start kibana &>>/tmp/elastic.log
Stat $? "Start Kibana"


yum install logstash --enablerepo=elasticsearch -y &>>/tmp/elastic.log
Stat $? "Install LogStash"

echo 'input {
  beats {
    port => 5044
  }
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}"
  }
}' >/etc/logstash/conf.d/logstash.conf

systemctl enable logstash &>>/tmp/elastic.log
systemctl start logstash &>>/tmp/elastic.log
Stat $? "Start Logstash"

yum install nginx -y &>/dev/null
Stat $? "Install Nginx"


curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/elk/http-proxy.conf >/etc/nginx/nginx.conf
systemctl enable nginx
systemctl start nginx
Stat $? "Start Kibana"

#!/bin/bash 

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

echo '[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md' > /etc/yum.repos.d/elastic.repo
yum install --enablerepo=elasticsearch elasticsearch -y

IPADDR=$(hostname -i | awk '{print $NF}')
sed -i -e "/network.host/ c network.host: 0.0.0.0" -e "/http.port/ c http.port: 9200" -e "/cluster.initial_master_nodes/ c cluster.initial_master_nodes: \[\"${IPADDR}\"\]" /etc/elasticsearch/elasticsearch.yml

systemctl enable elasticsearch
systemctl start elasticsearch

yum install kibana  --enablerepo=elasticsearch -y
systemctl enable kibana
systemctl start kibana

yum install logstash --enablerepo=elasticsearch -y
systemctl enable logstash
systemctl  start logstash

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

yum install nginx -y &>/dev/null
curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/elk/http-proxy.conf >/etc/nginx/nginx.conf
systemctl enable nginx
systemctl start nginx
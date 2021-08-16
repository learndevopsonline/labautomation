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
systemctl enable elasticsearch
systemctl start elasticsearch --enablerepo=elasticsearch -y

yum install kibana -y
systemctl enable kibana
systemctl start kibana



exit 0


Y="\e[33m"
N="\e[0m"

STAT() {
  if [ $1 -ne 0 ]; then 
    echo "\e[31mFAILED\e[0m"
    exit 1
  fi 
}

Print() {
  echo -e "${Y}${1}${N}"
}

if [ "$SKIP" != "TRUE" ]; then 
  ## Install html2text 
  Print "Installing Html2text"

  yum install epel-release https://li.nux.ro/download/nux/dextop/el7/x86_64/html2text-1.3.2a-14.el7.nux.x86_64.rpm -y  &>/dev/null
  STAT $?
  VERSION=$(curl -s -L https://www.elastic.co/downloads/elasticsearch  | html2text  | grep Version -A 1 | tail -1)

  echo VERSION = ${VERSION}

  Print "Installing Elasicsearch"
  yum install https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${VERSION}-x86_64.rpm -y &>/tmp/lab.log
  STAT $? 

  Print "Installing Kibana"
  yum install https://artifacts.elastic.co/downloads/kibana/kibana-${VERSION}-x86_64.rpm -y &>>/tmp/lab.log
  STAT $? 

  Print "Installing Java"
  yum install java -y &>/dev/null 
  STAT $?

  Print "Installing Logstash"
  yum install https://artifacts.elastic.co/downloads/logstash/logstash-${VERSION}-x86_64.rpm -y &>>/tmp/lab.log
  STAT $? 
fi 

IPADDR=$(hostname -i | awk '{print $NF}')
sed -i -e "/network.host/ c network.host: 0.0.0.0" -e "/http.port/ c http.port: 9200" -e "/cluster.initial_master_nodes/ c cluster.initial_master_nodes: \[\"${IPADDR}\"\]" /etc/elasticsearch/elasticsearch.yml

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
systemctl enable elasticsearch 
systemctl enable kibana 
systemctl enable logstash 

Print "Starting nginx"
systemctl start nginx 
Print "Starting elasticsearch"
systemctl start elasticsearch 
Print "Starting kibana"
systemctl start kibana 
Print "Starting Logstash"
systemctl start logstash  


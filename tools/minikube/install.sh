#!/bin/bash

type minikube &>/dev/null
if [ $? -ne 0 ]; then
  dnf install https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm -y
fi

docker ps &>/dev/null
if [ $? -ne 0 ]; then
  yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
  yum install docker-ce --nobest -y
  systemctl enable docker
  systemctl start docker
  curl -L -o /tmp/crictl-v1.30.0-linux-amd64.tar.gz  https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.30.0/crictl-v1.30.0-linux-amd64.tar.gz
  cd /bin
  tar -xf /tmp/crictl-v1.30.0-linux-amd64.tar.gz
  curl -L -o /tmp/cri-dockerd-0.3.14.amd64.tgz https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.14/cri-dockerd-0.3.14.amd64.tgz
  cd /tmp/
  tar -xf /tmp/cri-dockerd-0.3.14.amd64.tgz
  mv cri-dockerd/cri-dockerd /bin
  cd /tmp
  rm -rf cri-dockerd
  git clone https://github.com/Mirantis/cri-dockerd.git
  cp  cri-dockerd/packaging/systemd/* /etc/systemd/system
  systemctl daemon-reload
  systemctl start cri-docker
  systemctl enable cri-docker
  curl -L -o /bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x /bin/kubectl
fi

echo "Running the following command - minikube start --force"
minikube start --force

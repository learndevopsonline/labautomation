#!/bin/bash 

curl -s https://gitlab.com/cit-devops/intros/raw/master/ami-setup.sh | sudo bash 
curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/docker/install-docker-ce.sh | sudo bash 
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
mv kubectl /bin
chmod +x /bin/kubectl 
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo mv minikube /bin 
sudo chmod +x /bin/minikube 


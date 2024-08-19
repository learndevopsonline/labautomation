#!/bin/bash 

#curl -s https://gitlab.com/cit-devops/intros/raw/master/ami-setup.sh | sudo bash
#curl -s https://raw.githubusercontent.com/learndevopsonline/labautomation/master/tools/docker/install-docker-ce.sh | sudo bash
#curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
#mv kubectl /bin
#chmod +x /bin/kubectl
#curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
#sudo mv minikube /bin
#sudo chmod +x /bin/minikube
#

type terraform || bash tools/terraform/install.sh

cd tools/minikube

if [ ! -f "~/.ssh/id_rsa.pub" ]; then
  cat /dev/zero | ssh-keygen -q -N ""
fi

echo
echo
echo
echo "Ensure you open the following URL and subscribe. Wait for Subscription to Complete and Press Enter to Continue"
echo "https://aws.amazon.com/marketplace/pp/prodview-foff247vr2zfw?ref_=aws-mp-console-subscription-detail"
read -p ""

cd terraform
rm -rf .terraform*

terraform init
terraform apply -auto-approve


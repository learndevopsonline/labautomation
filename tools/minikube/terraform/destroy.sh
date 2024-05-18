#!/bin/bash 

cd tools/minikube
terraform init
terraform destroy -auto-approve

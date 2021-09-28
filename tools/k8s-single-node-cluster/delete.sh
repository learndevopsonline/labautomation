#!/bin/bash

read -p 'Enter DNS Hosted Zone Name: ' hname
export TF_VAR_HOSTED_ZONE=${hname}
terraform init
terraform destroy -auto-approve

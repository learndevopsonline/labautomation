#!/bin/bash

read -p 'Enter Instance Name: ' name
[ -z "$name" ] && echo "Instance Name is Empty" && exit 1

aws ec2 describe-instances --query 'Reservations[*].Instances[*].{Instance:InstanceId,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress,State:State.Name,Name:Tags[?Key==`Name`]|[0].Value}' --output table | grep $name

#echo -n -e "\e[1;33mEnter Instance ID\e[0m: "
#read -p '' instance_id

#aws ec2 describe-instances --instance-ids $instance_id --output json | jq .


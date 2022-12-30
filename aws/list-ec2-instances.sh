#!/bin/bash

aws ec2 describe-instances --query 'Reservations[*].Instances[*].{Instance:InstanceId,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress,State:State.Name,Name:Tags[?Key==`Name`]|[0].Value}' --output table


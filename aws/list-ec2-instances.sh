#!/bin/bash

aws ec2 describe-instances --query 'Reservations[*].Instances[*].{Instance:InstanceId,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress,State:State}' --output table

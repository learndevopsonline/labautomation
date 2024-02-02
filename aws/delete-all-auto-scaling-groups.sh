#!/bin/bash

LIST=$(aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].AutoScalingGroupName' --output text | xargs)

for i in $LIST ; do
  echo ">>>  Deleting ASG - $i  <<<"
  aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $i --force-delete
done

#!/bin/bash

source /tmp/labautomation/aws/commons

AMI=$(FIND_AMI)

CHOOSE_INSTANCE_TYPE
ENTER_INSTANCE_NAME
CHOOSE_SG_ID

aws ec2 run-instances --image-id ${AMI} --instance-type ${INSTANCE_TYPE} --output text --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${INSTANCE_NAME}}]" "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${INSTANCE_NAME}}]"  --instance-market-options "MarketType=spot,SpotOptions={InstanceInterruptionBehavior=stop,SpotInstanceType=persistent}" --security-group-ids "${SG_ID}"  &>>$LOG

#!/bin/bash

aws ec2 describe-images --owners self --query "Images[*].{Name: Name, ID: ImageId}" --output table

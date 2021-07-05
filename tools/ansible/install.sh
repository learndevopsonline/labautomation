#!/bin/bash 

yum install ansible -y
yum remove ansible -y 
rm -rf /usr/lib/python2.7/site-packages/ansible*
pip install ansible==3.4.0

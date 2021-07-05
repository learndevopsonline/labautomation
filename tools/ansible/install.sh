#!/bin/bash 

yum install ansible -y
yum remove ansible -y 
rm -rf /usr/lib/python2.7/site-packages/ansible*
pip install ansible==4.1.0 ansible-core==2.11.1 

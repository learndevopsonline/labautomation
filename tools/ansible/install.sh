#!/bin/bash 

sudo yum remove ansible -y 
rm -rf /usr/lib/python2.7/site-packages/ansible*
sudo pip install ansible 

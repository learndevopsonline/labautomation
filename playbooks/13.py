#!/usr/bin/python

#print 'Hello World'
import os
from termcolor import colored

### Functions
def Stat(stat):
    if stat == 0:
        print colored('SUCCESS', 'green')
    else:
        print colored('FAILED','red')

## Main program
REPO_URL='http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm'
out=os.system("rpm -qa | grep -w zabbix-release &>/dev/null")
if out != 0:
    print 'Installing REPO packages',
    out=os.system("rpm -ivh "+ REPO_URL + " &>/dev/null")
    Stat(out)


#!/usr/bin/python

#print 'Hello World'
import os
from termcolor import colored

REPO_URL='http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm'

print colored('hello', 'red'), colored('world', 'green')
print "Nope, that is not a two. That is a",
print 'hello hello'

out=os.system("rpm -qa | grep -w zabbix-release &>/dev/null")
if out != 0:
    print ""
    OSA=os.system("rpm -ivh "+ REPO_URL + " &>/dev/null")
    #print OSA


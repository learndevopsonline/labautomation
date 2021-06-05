#!/usr/bin/python

#print 'Hello World'
import os
from termcolor import colored
import MySQLdb

db = MySQLdb.connect(host="localhost",
                        user='root', 
                        passwd='') 

### Functions
def Stat(stat):
    if stat == 100: 
        print colored('SKIPPING', 'cyan')
    elif stat == 0:
        print colored('SUCCESS', 'green')
    else:
        print colored('FAILED','red')

def Print(msg):
    print msg + '\t--\t',

## Main program
REPO_URL='http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm'
Print('Installing REPO packages')
out=os.system("rpm -qa | grep -w zabbix-release &>/dev/null")
if out != 0:
    out=os.system("rpm -ivh "+ REPO_URL + " &>/dev/null")
    Stat(out)
else:
    Stat(100)

Print('Installing Zabbix Server')
out=os.system('rpm -q zabbix-server-mysql &>/dev/null')
if out != 0:
    out=os.system('yum install zabbix-server-mysql -y &>/dev/null')
    Stat(out)
else:
    Stat(100)

Print('Installing MariaDB Server')
out=os.system('rpm -q mariadb-server mariadb-devel gcc python-devel &>/dev/null')
if out != 0:    
    out=os.system('yum install mariadb-server -y &>/dev/null')
    Stat(out)
    os.system('systemctl enable mariadb &>/dev/null && systemctl start mariadb')
else:
    Stat(100)

cur = db.cursor()
cur.execute('create database if not exists zabbix;')
cur.execute('grant all privileges on zabbix.* to "zabbix"@"localhost" identified by "zabbix"')
out.system('zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -pzabbix zabbix')


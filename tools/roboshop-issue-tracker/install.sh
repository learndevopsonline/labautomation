source /tmp/labautomation/dry/common-functions.sh
pwd

source tools/roboshop-issue-tracker/functions

## Frontend
PrintCenter "RoboShop Project Setup Issue Finder"

echo This script runs only on the frontend server. Other servers it will always fail.
chatgpt_print Checking Frontend!!

chatgpt_print FRONTEND: Checking if the nginx is installed

command_print "yum list installed | grep nginx.x"

yum list installed | grep nginx.x
StatP $? "Nginx is installed"

chatgpt_print FRONTEND: Checking for Roboshop nginx configuration.

command_print "cat /etc/nginx/default.d/roboshop.conf"

cat /etc/nginx/default.d/roboshop.conf
StatP $? "Found RoboShop Configuration"
CASE EXIT

chatgpt_print FRONTEND: Checking Nginx Service is running or not.

command_print "netstat -lntp | grep nginx"

netstat -lntp | grep nginx
StatP $? "Nginx Service Running.."
CASE 10


















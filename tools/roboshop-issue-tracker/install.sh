echo -e "\n\e[33mThis script is under development, So all the scenarios may not work\e[0m"

source /tmp/labautomation/dry/common-functions.sh
source tools/roboshop-issue-tracker/functions

## Frontend

echo This script runs only on the frontend server. Other servers it will always fail.
chatgpt_print Checking Frontend!!

chatgpt_print FRONTEND: Checking if the nginx is installed

command_print "yum list installed | grep nginx.x"

yum list installed | grep nginx.x
StatP $? "Nginx is installed"

chatgpt_print FRONTEND: Checking for Roboshop nginx configuration.

command_print "cat /etc/nginx/default.d/roboshop.conf"

cat /etc/nginx/default.d/roboshop.conf
EXIT=1 StatP $? "Found RoboShop Configuration"

chatgpt_print FRONTEND: Checking Nginx Service is running or not.
set -x
command_print "netstat -lntp | grep nginx"

netstat -lntp | grep nginx
EXIT=0 StatP $? "Nginx Service Running.."
CASE 10


















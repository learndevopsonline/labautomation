echo -e "\n\e[33mThis script is under development, So all the scenarios may not work\e[0m"

source /tmp/labautomation/dry/common-functions.sh
source tools/roboshop-issue-tracker/functions
source tools/roboshop-issue-tracker/solutions

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

command_print "netstat -lntp | grep nginx"

netstat -lntp | grep nginx
EXIT=0 StatP $? "Nginx Service Running.."
CASE 10


# Finding Catalogue Server
command_print "cat /etc/nginx/default.d/roboshop.conf  | grep catalogue  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print \$1}'"

CAT_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep catalogue  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print $1}')

chatgpt_print "Catalogue IP : $CAT_IP"

command_print "nc -z $CAT_IP 22"
nc -z $CAT_IP 22
StatP $? "Checking Catalogue Server is reachable"

# Finding User Server
command_print "cat /etc/nginx/default.d/roboshop.conf  | grep user  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print \$1}'"

USE_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep user  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print $1}')

chatgpt_print "USER IP : $USE_IP"

command_print "nc -z $USE_IP 22"
nc -z $USE_IP 22
StatP $? "Checking User Server is reachable"

# Finding Cart Server
command_print "cat /etc/nginx/default.d/roboshop.conf  | grep cart  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print \$1}'"

CAR_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep cart  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print $1}')

chatgpt_print "Cart IP : $CAR_IP"

command_print "nc -z $CAR_IP 22"
nc -z $CAR_IP 22
StatP $? "Checking Cart Server is reachable"

# Finding Shipping Server
command_print "cat /etc/nginx/default.d/roboshop.conf  | grep shipping  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print \$1}'"

SHI_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep shipping  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print $1}')

chatgpt_print "Shipping IP : $SHI_IP"

command_print "nc -z $SHI_IP 22"
nc -z $SHI_IP 22
StatP $? "Checking Shipping Server is reachable"













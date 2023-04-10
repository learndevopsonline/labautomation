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
CASE 100


# Finding Catalogue Server
command_print "cat /etc/nginx/default.d/roboshop.conf  | grep catalogue  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print \$1}'"

CAT_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep catalogue  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print $1}')

chatgpt_print "Catalogue IP : $CAT_IP"

command_print "nc -z $CAT_IP 22"
nc -z $CAT_IP 22
StatP $? "Checking Catalogue Server is reachable"


### Checking Catalogue service is running or not.
chatgpt_print "CATALOGUE: Check if the catalogue service is running or not"
command_print "ps -ef | grep server.js"
echo "ps -ef | grep server.js | grep -v grep" | ssh $CAT_IP 2>&1 | sed -e 1,39d | grep server.js
StatP $? "Checking Catalogue Service is running"

chatgpt_print "CATALOGUE: Catalogue Service is dependent on MongoDB Server. Fetching MongoDB IP address"

MONGO_IP=$(echo "cat /etc/systemd/system/catalogue.service | grep MONGO_URL  | awk -F / '{print \$3}' | awk -F : '{print \$1}'" | ssh $CAT_IP 2>&1 | sed -e 1,39d)

chatgpt_print "MongoDB IP : $MONGO_IP"

command_print "nc -z $MONGO_IP 22"
nc -z $MONGO_IP 22
StatP $? "Checking MongoDB Server is reachable"

chatgpt_print "MONGODB: Checking if the DB is running or not"
command_print "netstat -lntp"

listen_addres=$(remote_command $MONGO_IP "netstat -lntp | grep mongo | awk -F : '{print \$1}' | awk '{print \$NF}'")
echo $listen_addres

if [ "$listen_addres" != "0.0.0.0" ]; then
  EXIT=0 StatP 1 "MongoDB listen address is configured"
  CASE 200
fi




exit

# Finding User Server
command_print "cat /etc/nginx/default.d/roboshop.conf  | grep user  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print \$1}'"

USE_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep user  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print $1}')

chatgpt_print "User IP : $USE_IP"

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

chatgpt_print "SHIPPING: Check if the shipping service is running or not"

command_print "ps -ef | grep java"

echo "ps -ef | grep java | grep -v grep" | ssh $SHI_IP 2>&1 | sed -e 1,39d | grep java











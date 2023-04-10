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
if [ "$listen_addres" != "0.0.0.0" ]; then
  EXIT=0 StatP 1 "MongoDB listen address is configured"
  CASE 200
fi

chatgpt_print "MONGODB: Checking if catalogue is able to reach MongoDB Server or not"
command_print "nc -z $MONGO_IP 27017"
remote_command $CAT_IP "nc -z $MONGO_IP 27017"
Stat $? "Catalogue server able to connect to MongoDB server"

chatgpt_print "MONGODB: Checking if catalogue schema is loaded in mongodb"
command_print "echo 'show dbs' | mongo"
remote_command $MONGO_IP "echo 'show dbs' | mongo 2>&1" >/tmp/out

grep catalogue /tmp/out &>/dev/null
if [ $? -ne 0 ]; then
  grep READ__ME_TO_RECOVER_YOUR_DATA /tmp/out &>/dev/null
  if [ $? -eq 0 ]; then
    EXIT=0 StatP 1 "Checking Catalogue Schema"
    CASE 201
  else
    EXIT=0 StatP 1 "Checking Catalogue Schema"
    CASE 202
  fi
else
  StatP 0 "Checking Catalogue Schema"
fi


# Finding User Server
command_print "cat /etc/nginx/default.d/roboshop.conf  | grep user  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print \$1}'"

USE_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep user  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print $1}')

chatgpt_print "User IP : $USE_IP"

command_print "nc -z $USE_IP 22"
nc -z $USE_IP 22
StatP $? "Checking User Server is reachable"

chatgpt_print "USER: User Service is dependent on MongoDB Server. Fetching MongoDB IP address"

MONGO_IP=$(echo "cat /etc/systemd/system/user.service | grep MONGO_URL  | awk -F / '{print \$3}' | awk -F : '{print \$1}'" | ssh $USE_IP 2>&1 | sed -e 1,39d)

chatgpt_print "MongoDB IP : $MONGO_IP"

command_print "nc -z $MONGO_IP 22"
nc -z $MONGO_IP 22
StatP $? "Checking MongoDB Server is reachable"

chatgpt_print "MONGODB: Checking if the DB is running or not"
command_print "netstat -lntp"

listen_addres=$(remote_command $MONGO_IP "netstat -lntp | grep mongo | awk -F : '{print \$1}' | awk '{print \$NF}'")
if [ "$listen_addres" != "0.0.0.0" ]; then
  EXIT=0 StatP 1 "MongoDB listen address is configured"
  CASE 200
fi

chatgpt_print "MONGODB: Checking if user is able to reach MongoDB Server or not"
command_print "nc -z $MONGO_IP 27017"
remote_command $CAT_IP "nc -z $MONGO_IP 27017"
Stat $? "User server able to connect to MongoDB server"

chatgpt_print "MONGODB: Checking if user schema is loaded in mongodb"
command_print "echo 'show dbs' | mongo"
remote_command $MONGO_IP "echo 'show dbs' | mongo 2>&1" >/tmp/out

grep users  /tmp/out &>/dev/null
if [ $? -ne 0 ]; then
  grep READ__ME_TO_RECOVER_YOUR_DATA /tmp/out &>/dev/null
  if [ $? -eq 0 ]; then
    EXIT=0 StatP 1 "Checking User Schema"
    CASE 201
  else
    EXIT=0 StatP 1 "Checking User Schema"
    CASE 202
  fi
else
  StatP 0 "Checking User Schema"
fi

chatgpt_print "USER: User Service is dependent on Redis Server. Fetching Redis IP address"

REDIS_IP=$(echo "cat /etc/systemd/system/user.service  | grep REDIS_HOST  | awk -F = '{print \$NF}'" | ssh $USE_IP 2>&1 | sed -e 1,39d)

chatgpt_print "Redis IP : $REDIS_IP"

command_print "nc -z $REDIS_IP 22"
nc -z $REDIS_IP 22
StatP $? "Checking Redis Server is reachable"

chatgpt_print "REDIS: Checking if the Redis is running or not"
command_print "netstat -lntp"

listen_addres=$(remote_command $REDIS_IP "netstat -lntp | grep redis | awk -F : '{print \$1}' | awk '{print \$NF}' | head -1")
if [ "$listen_addres" != "0.0.0.0" ]; then
  EXIT=0 StatP 1 "REDIS listen address is configured"
  CASE 400
else
  StatP 0 "REDIS listen address is configured"
fi

chatgpt_print "USER: Checking if user is able to reach Redis Server or not"
command_print "nc -z $REDIS_IP 6379"
remote_command $USE_IP "nc -z $REDIS_IP 6379"
Stat $? "User server able to connect to Redis server"

# Finding Cart Server
command_print "cat /etc/nginx/default.d/roboshop.conf  | grep cart  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print \$1}'"

CAR_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep cart  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print $1}')

chatgpt_print "Cart IP : $CAR_IP"

command_print "nc -z $CAR_IP 22"
nc -z $CAR_IP 22
StatP $? "Checking Cart Server is reachable"

chatgpt_print "USER: User Service is dependent on Redis Server. Fetching Redis IP address"

REDIS_IP=$(echo "cat /etc/systemd/system/cart.service  | grep REDIS_HOST  | awk -F = '{print \$NF}'" | ssh $CAR_IP 2>&1 | sed -e 1,39d)

chatgpt_print "Redis IP : $REDIS_IP"

command_print "nc -z $REDIS_IP 22"
nc -z $REDIS_IP 22
StatP $? "Checking Redis Server is reachable"

chatgpt_print "REDIS: Checking if the Redis is running or not"
command_print "netstat -lntp"

listen_addres=$(remote_command $REDIS_IP "netstat -lntp | grep redis | awk -F : '{print \$1}' | awk '{print \$NF}' | head -1")
if [ "$listen_addres" != "0.0.0.0" ]; then
  EXIT=0 StatP 1 "REDIS listen address is configured"
  CASE 400
else
  StatP 0 "REDIS listen address is configured"
fi

chatgpt_print "CART: Checking if cart is able to reach Redis Server or not"
command_print "nc -z $REDIS_IP 6379"
remote_command $CAR_IP "nc -z $REDIS_IP 6379"
Stat $? "Cart server able to connect to Redis server"

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











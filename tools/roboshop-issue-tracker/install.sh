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

command_print "nc -w 5 -z $CAT_IP 22"
nc -w 5 -z $CAT_IP 22
StatP $? "Checking Catalogue Server is reachable" || CASE 0

### Printing Service File
chatgpt_print "CATALOGUE: Fetching SystemD File"
command_print "cat /etc/systemd/system/catalogue.service"
remote_command $CAT_IP "cat /etc/systemd/system/catalogue.service"
StatP $? "Fetching Catalogue Service File" || CASE 1

### Checking Catalogue service is running or not.
chatgpt_print "CATALOGUE: Check if the catalogue service is running or not"
command_print "ps -ef | grep server.js"
remote_command $CAT_IP "ps -ef | grep server.js | grep -v grep"
StatP $? "Checking Catalogue Service is running"

chatgpt_print "CATALOGUE: Catalogue Service is dependent on MongoDB Server. Fetching MongoDB IP address"
MONGO_IP=$(remote_command $CAT_IP "cat /etc/systemd/system/catalogue.service | grep MONGO_URL  | awk -F / '{print \$3}' | awk -F : '{print \$1}'")

chatgpt_print "MongoDB IP : $MONGO_IP"

command_print "nc -w 5 -z $MONGO_IP 22"
nc -w 5 -z $MONGO_IP 22
StatP $? "Checking MongoDB Server is reachable" || CASE 0

chatgpt_print "MONGODB: Checking if the DB is running or not"
command_print "netstat -lntp"
remote_command $MONGO_IP "netstat -lntp"

listen_addres=$(remote_command $MONGO_IP "netstat -lntp | grep mongo | awk -F : '{print \$1}' | awk '{print \$NF}'")
if [ "$listen_addres" != "0.0.0.0" ]; then
  EXIT=0 StatP 1 "MongoDB listen address is configured"
  CASE 200
else
  StatP 0 "MongoDB listen address is configured"
fi

chatgpt_print "CATALOGUE: Checking if catalogue is able to reach MongoDB Server or not"
command_print "nc -w 5 -z $MONGO_IP 27017"
remote_command $CAT_IP "nc -w 5 -z $MONGO_IP 27017"
Stat $? "Catalogue server able to connect to MongoDB server"

chatgpt_print "MONGODB: Checking if catalogue schema is loaded in mongodb"
command_print "echo 'show dbs' | mongo"
remote_command $MONGO_IP "echo 'show dbs' | mongo 2>&1" >/tmp/out
cat /tmp/out | grep --color -E 'catalogue|$'

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

remote_command $CAT_IP "systemctl restart catalogue"


# Finding User Server
command_print "cat /etc/nginx/default.d/roboshop.conf  | grep user  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print \$1}'"

USE_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep user  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print $1}')

chatgpt_print "User IP : $USE_IP"

command_print "nc -w 5 -z $USE_IP 22"
nc -w 5 -z $USE_IP 22
StatP $? "Checking User Server is reachable" || CASE 0

### Printing Service File
chatgpt_print "USER: Fetching SystemD File"
command_print "cat /etc/systemd/system/user.service"
remote_command $USE_IP "cat /etc/systemd/system/user.service"
StatP $? "Fetching User Service File" || CASE 1

chatgpt_print "USER: User Service is dependent on MongoDB Server. Fetching MongoDB IP address"
MONGO_IP=$(remote_command $USE_IP "cat /etc/systemd/system/user.service | grep MONGO_URL  | awk -F / '{print \$3}' | awk -F : '{print \$1}'")
chatgpt_print "MongoDB IP : $MONGO_IP"

command_print "nc -w 5 -z $MONGO_IP 22"
nc -w 5 -z $MONGO_IP 22
StatP $? "Checking MongoDB Server is reachable" || CASE 0

chatgpt_print "MONGODB: Checking if the DB is running or not"
command_print "netstat -lntp"
remote_command $MONGO_IP "netstat -lntp"

listen_addres=$(remote_command $MONGO_IP "netstat -lntp | grep mongo | awk -F : '{print \$1}' | awk '{print \$NF}'")
if [ "$listen_addres" != "0.0.0.0" ]; then
  EXIT=0 StatP 1 "MongoDB listen address is configured"
  CASE 200
fi

chatgpt_print "USER: Checking if user is able to reach MongoDB Server or not"
command_print "nc -w 5 -z $MONGO_IP 27017"
remote_command $USE_IP "nc -w 5 -z $MONGO_IP 27017"
Stat $? "User server able to connect to MongoDB server"

chatgpt_print "MONGODB: Checking if user schema is loaded in mongodb"
command_print "echo 'show dbs' | mongo"
remote_command $MONGO_IP "echo 'show dbs' | mongo 2>&1" >/tmp/out
cat /tmp/out | grep --color -E 'users|$'

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
REDIS_IP=$(remote_command $USE_IP "cat /etc/systemd/system/user.service  | grep REDIS_HOST  | awk -F = '{print \$NF}'")
if [ "$REDIS_IP" == "<REDIS-SERVER-IP>" -o -z "$REDIS_IP" ]; then
  EXIT=0 StatP 1 "Redis IP Not Configured in User Service File"
  CASE 500
fi
chatgpt_print "Redis IP : $REDIS_IP"

command_print "nc -w 5 -z $REDIS_IP 22"
nc -w 5 -z $REDIS_IP 22
StatP $? "Checking Redis Server is reachable" || CASE 0

chatgpt_print "REDIS: Checking if the Redis is running or not"
command_print "netstat -lntp"
remote_command $REDIS_IP "netstat -lntp"

listen_addres=$(remote_command $REDIS_IP "netstat -lntp | grep redis | awk -F : '{print \$1}' | awk '{print \$NF}' | head -1")
if [ "$listen_addres" != "0.0.0.0" ]; then
  EXIT=0 StatP 1 "REDIS listen address is configured"
  CASE 400
else
  StatP 0 "REDIS listen address is configured"
fi

chatgpt_print "USER: Checking if user is able to reach Redis Server or not"
command_print "nc -w 5 -z $REDIS_IP 6379"
remote_command $USE_IP "nc -w 5 -z $REDIS_IP 6379"
if [ "$?" -eq 1 ]; then
  EXIT=0 StatP 1 "User server able to connect to Redis server"
  CASE 401
else
  StatP 0 "User server able to connect to Redis server"
fi

remote_command $USE_IP "systemctl restart user"


## Finding Cart Server
command_print "cat /etc/nginx/default.d/roboshop.conf  | grep cart  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print \$1}'"
CAR_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep cart  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print $1}')

chatgpt_print "Cart IP : $CAR_IP"

command_print "nc -w 5 -z $CAR_IP 22"
nc -w 5 -z $CAR_IP 22
StatP $? "Checking Cart Server is reachable" || CASE 0

### Printing Service File
chatgpt_print "CART: Fetching SystemD File"
command_print "cat /etc/systemd/system/cart.service"
remote_command $CAR_IP "cat /etc/systemd/system/cart.service"
StatP $? "Fetching Cart Service File" || CASE 1

chatgpt_print "USER: User Service is dependent on Redis Server. Fetching Redis IP address"
check_config_file $CAR_IP /etc/systemd/system/cart.service
REDIS_IP=$(remote_command $CAR_IP "cat /etc/systemd/system/cart.service  | grep REDIS_HOST  | awk -F = '{print \$NF}'")

chatgpt_print "Redis IP : $REDIS_IP"

command_print "nc -w 5 -z $REDIS_IP 22"
nc -w 5 -z $REDIS_IP 22
StatP $? "Checking Redis Server is reachable"

chatgpt_print "REDIS: Checking if the Redis is running or not"
command_print "netstat -lntp"
remote_command $REDIS_IP "netstat -lntp"

listen_addres=$(remote_command $REDIS_IP "netstat -lntp | grep redis | awk -F : '{print \$1}' | awk '{print \$NF}' | head -1")
if [ "$listen_addres" != "0.0.0.0" ]; then
  EXIT=0 StatP 1 "REDIS listen address is configured"
  CASE 400
else
  StatP 0 "REDIS listen address is configured"
fi

chatgpt_print "CART: Checking if cart is able to reach Redis Server or not"
command_print "nc -w 5 -z $REDIS_IP 6379"
remote_command $CAR_IP "nc -w 5 -z $REDIS_IP 6379"
Stat $? "Cart server able to connect to Redis server"

chatgpt_print "CART: Redis needs to be installed"


#### Redis version has to be 6.2.x


## Finding Shipping Server
command_print "cat /etc/nginx/default.d/roboshop.conf  | grep shipping  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print \$1}'"
SHI_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep shipping  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print $1}')

chatgpt_print "Shipping IP : $SHI_IP"
command_print "nc -w 5 -z $SHI_IP 22"
nc -w 5 -z $SHI_IP 22
StatP $? "Checking Shipping Server is reachable" || CASE 0

### Printing Service File
chatgpt_print "SHIPPING: Fetching SystemD File"
command_print "cat /etc/systemd/system/shipping.service"
remote_command $SHI_IP "cat /etc/systemd/system/shipping.service"
StatP $? "Fetching Shipping Service File" || CASE 1

chatgpt_print "SHIPPING: Check if the shipping service is running or not"
command_print "ps -ef | grep java"
remote_command $SHI_IP "ps -ef | grep java | grep -v grep"
Stat $? "Check Shipping is running or not"

## Finding Payment Server
command_print "cat /etc/nginx/default.d/roboshop.conf  | grep payment  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print \$1}'"
PAY_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep payment  | xargs -n1 | grep ^http | sed -e 's|http://||' | awk -F : '{print $1}')

chatgpt_print "Payment IP : $PAY_IP"
command_print "nc -w 5 -z $PAY_IP 22"
nc -w 5 -z $PAY_IP 22
StatP $? "Checking Payment Server is reachable" || CASE 0

### Printing Service File
chatgpt_print "PAYMENT: Fetching SystemD File"
command_print "cat /etc/systemd/system/payment.service"
remote_command $PAY_IP "cat /etc/systemd/system/payment.service"
StatP $? "Fetching Payment Service File" || CASE 1

chatgpt_print "PAYMENT: Check if the payment service is running or not"
command_print "ps -ef | grep payment"
remote_command $PAY_IP "ps -ef | grep payment | grep -v grep"
Stat $? "Check Payment is running or not"

chatgpt_print "PAYMENT: Payment Service is dependent on RabbitMQ Server. Fetching RabbitMQ IP address"
RABBITMQ_IP=$(remote_command $PAY_IP "cat /etc/systemd/system/payment.service  | grep AMQP_HOST | awk -F = '{print \$NF}'")

chatgpt_print "RabbitMQ IP : $RABBITMQ_IP"

command_print "nc -w 5 -z $RABBITMQ_IP 22"
nc -w 5 -z $RABBITMQ_IP 22
StatP $? "Checking RabbitMQ Server is reachable" || CASE 0

chatgpt_print "RABBITMQ: Checking if the RabbitMQ is running or not"
command_print "netstat -lntp"
remote_command $RABBITMQ_IP "netstat -lntp"

check_rabbitmq=$(remote_command $RABBITMQ_IP "netstat -lntp | grep '5672' |wc -l")
if [ "$check_rabbitmq" -eq 0 ]; then
  EXIT=0 StatP 1 "RabbitMQ Service not running"
  CASE 900
else
  StatP 0 "RabbitMQ Service running"
fi

chatgpt_print "PAYMENT: Payment application talks to rabbitmq with a application user, Getting Application Username & Password"
RABBITMQ_USER=$(remote_command $PAY_IP "cat /etc/systemd/system/payment.service  | grep AMQP_USER | awk -F = '{print \$NF}'")
RABBITMQ_PASS=$(remote_command $PAY_IP "cat /etc/systemd/system/payment.service  | grep AMQP_PASS | awk -F = '{print \$NF}'")

chatgpt_print "RabbitMQ Username & Password : $RABBITMQ_USER / $RABBITMQ_PASS"
if [ -z "$RABBITMQ_USER" -o -z "$RABBITMQ_PASS" -o "$RABBITMQ_PASS" == "rabbitmq_appuser_password" ]; then
  EXIT=0 StatP 1 "RabbitMQ Credentials are missing in the service file"
  CASE 1000
fi








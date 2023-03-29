#!/bin/bash

source $(dirname $0)/functions

NLPRINT
NLPRINT
RBPRINT "This script helps you to Check the Issues of RoboShop"
BPRINT  "Note: This script is still under development and does not have all the cases ready yet."

PRINT   "\nThis script runs only in FRONTEND, Hence if you are sure that you are \nrunning under frontend server then proceed.."
read -p 'Proceed [Y|n]: ' action

ACTION=$(echo $action| cut -c -1 | tr [a-z] [A-Z])
if [ "$ACTION" == "Y" ]; then
  if [ ! -f /etc/nginx/default.d/roboshop.conf ]; then
    echo -e "\e[1;33mUnable to find the Frontend Nginx Setup, Exiting.."
    exit 1
  fi
else
  exit
fi

## Component - 1 - Scenario 1

DLIM_UP
echo -e "\e[1m Checking Nginx Configuration\e[0m"
DLIM_DOWN

for component in catalogue cart user shipping payment ; do
  [ "$component" == "cart" -o "$component" == "user" ] && TAB="\t"
  echo -n -e "Checking \e[1m$component\e[0m Config.. \t${TAB}"
  OUT=$(grep $component /etc/nginx/default.d/roboshop.conf | xargs -n1 | grep ^http | awk -F '[:,/]' '{print $4}')
  if [ "$OUT" != "localhost" ]; then
    echo -e "\e[1;32m Config Found\e[0m - \e[1m Will Check Further for this component\e[0m"
    FINAL="$FINAL $component"
  else
    echo -e "\e[1;31m Config Not Found\e[0m - \e[1m Will Not Check Further for this component\e[0m"
  fi
  unset TAB
done
DLIM

NLPRINT
DLIM_UP
PRINT "Extracting List of Server Details"
DLIM_DOWN
CATALOGUE_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep -i catalogue  | awk -F : '{print $(NF-1)}' | sed -e 's|//||')
BPRINT "CATALOGUE_IP\t= ${CATALOGUE_IP}"
USER_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep -i user  | awk -F : '{print $(NF-1)}' | sed -e 's|//||')
BPRINT "USER_IP\t\t= ${USER_IP}"
CART_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep -i cart  | awk -F : '{print $(NF-1)}' | sed -e 's|//||')
BPRINT "CART_IP\t\t= ${CART_IP}"
SHIPPING_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep -i shipping  | awk -F : '{print $(NF-1)}' | sed -e 's|//||')
BPRINT "SHIPPING_IP\t= ${SHIPPING_IP}"
PAYMENT_IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep -i payment  | awk -F : '{print $(NF-1)}' | sed -e 's|//||')
BPRINT "PAYMENT_IP\t= ${PAYMENT_IP}"
DLIM

NLPRINT
DLIM_UP
PRINT "Checking SSH Connections to App Servers"
DLIM_DOWN
CHECK_SSH_CONNECTION ${CATALOGUE_IP} && CATALOGUE_CHECK=1 || CATALOGUE_CHECK=0
CHECK_SSH_CONNECTION ${USER_IP} && USER_CHECK=1 || USER_CHECK=0
CHECK_SSH_CONNECTION ${CART_IP} && CART_CHECK=1 || CART_CHECK=0
CHECK_SSH_CONNECTION ${SHIPPING_IP} && SHIPPING_CHECK=1 || SHIPPING_CHECK=0
CHECK_SSH_CONNECTION ${PAYMENT_IP} && PAYMENT_CHECK=1 || PAYMENT_CHECK=0
DLIM

NLPRINT
DLIM_UP
PRINT "Finding DB Server Details"
DLIM_DOWN
scp ${CATALOGUE_IP}:/etc/systemd/system/catalogue.service /tmp &>/dev/null
scp ${USER_IP}:/etc/systemd/system/user.service /tmp &>/dev/null
scp ${SHIPPING_IP}:/etc/systemd/system/shipping.service /tmp &>/dev/null
scp ${PAYMENT_IP}:/etc/systemd/system/payment.service /tmp  &>/dev/null
MONGODB_IP=$(cat /tmp/catalogue.service  | grep MONGO_URL | awk -F '[:,/]' '{print $4}')
BPRINT "MONGODB_IP\t\t= ${MONGODB_IP}"
REDIS_IP=$(cat /tmp/user.service  | grep REDIS_HOST | awk -F = '{print $3}')
BPRINT "REDIS_IP\t\t= ${REDIS_IP}"
MYSQL_IP=$(cat /tmp/shipping.service  | grep DB_HOST | awk -F = '{print $3}')
BPRINT "MYSQL_IP\t\t= ${MYSQL_IP}"
RABBITMQ_IP=$(cat /tmp/payment.service  | grep AMQP_HOST | awk -F = '{print $3}')
BPRINT "RABBITMQ_IP\t\t= ${RABBITMQ_IP}"
DLIM

NLPRINT
DLIM_UP
PRINT "Checking SSH Connections to DB Servers"
DLIM_DOWN
CHECK_SSH_CONNECTION ${MONGODB_IP} && MONGO_CHECK=1 || MONGO_CHECK=0
CHECK_SSH_CONNECTION ${REDIS_IP} && REDIS_CHECK=1 || REDIS_CHECK=0
CHECK_SSH_CONNECTION ${MYSQL_IP} && MYSQL_CHECK=1 || MYSQL_CHECK=0
CHECK_SSH_CONNECTION ${RABBITMQ_IP} && RABBITMQ_CHECK=1 || RABBITMQ_CHECK=0
DLIM

## MongoDB Scenarios

NLPRINT
COMPONENT_HEAD MONGODB
SCENARIO_HEAD "MongoDB Runs on Port 27017, Hence checking if that PORT we are able to reach or not"
STAT_CONNECTION $MONGODB_IP 27017 MongoDB
if [ $? -ne 0 ]; then
  SCENARIO_HEAD "MongoDB Service Should be Running for applications to work"
  ssh $MONGODB_IP 'systemctl status mongod -l'
  STAT_SERVICE $MONGODB_IP mongod
  if [ $? -ne 0 ]; then
    EXIT "You need to Start the MongoDB Service \e[0m\e[1m(systemctl start mongod)"
    exit
  else
    SCENARIO_HEAD "MongoDB Service Should be Listening on 0.0.0.0 instead of 127.0.0.1"
    ssh ${MONGODB_IP} 'netstat -lntp' 2>/dev/null | tee /tmp/out
    LISTEN_IP=$(cat /tmp/out | grep 27017  | awk '{print $4}' | awk -F : '{print $1}')
    if [ "${LISTEN_IP}" != "0.0.0.0" ]; then
      EXIT "You need to update MongoDB Service in /etc/mongod.conf - Update 127.0.0.1 to 0.0.0.0"
    fi
  fi
else
  SCENARIO_HEAD "MongoDB should have schema loaded for our application to work"
  ssh ${MONGODB_IP} 'echo show dbs | mongo' 2>/dev/null | tee /tmp/out
  grep catalogue /tmp/out  &>/dev/null && grep users /tmp/out &>/dev/null
  if [ $? -eq 0 ]; then
    BPRINT "\nMongoDB Schema is Loaded"
  else
    EXIT "\nMongoDB need to have schema for the application to work, So follow documentation and load the schema"
  fi
  CONCLUDE "  🥳🎉👍 >> All Good with MongoDB"
fi


## Catalogue Scenarios
NLPRINT
COMPONENT_HEAD CATALOGUE
SCENARIO_HEAD "Catalogue Service should be running on Port 8080 and should be reachable to Frontend Service\nPort Check from Frontend to Catalogue"
STAT_CONNECTION ${CATALOGUE_IP} 8080 Catalogue

SCENARIO_HEAD "Checking If Catalogue is able to Connect to MongoDB"
MONGO_STATUS=$(curl -s http://${CATALOGUE_IP}:8080/health | jq .mongo)
if [ "${MONGO_STATUS}" != "true" ]; then
  CONCLUDE "  🥳🎉👍 >> All Good with Catalogue"
else
  STAT_SERVICE ${CATALOGUE_IP} catalogue
  if [ $? -ne 0 ]; then

    EXIT "You need to Start the Catalogue Service \e[0m\e[1m(systemctl start catalogue)"
    exit
  fi
fi



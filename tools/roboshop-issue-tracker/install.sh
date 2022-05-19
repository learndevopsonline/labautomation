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

DLIM
echo -e "\e[1m Checking Nginx Configuration\e[0m"
DLIM1

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

NLPRINT
DLIM
PRINT "Extracting List of Server Details"
DLIM
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
DLIM
PRINT "Checking SSH Connections"
DLIM
CHECK_SSH_CONNECTION ${CATALOGUE_IP} && CATALOGUE_CHECK=1 || CATALOGUE_CHECK=0
CHECK_SSH_CONNECTION ${USER_IP} && USER_CHECK=1 || USER_CHECK=0
CHECK_SSH_CONNECTION ${CART_IP} && CART_CHECK=1 || CART_CHECK=0
CHECK_SSH_CONNECTION ${SHIPPING_IP} && SHIPPING_CHECK=1 || SHIPPING_CHECK=0
CHECK_SSH_CONNECTION ${PAYMENT_IP} && PAYMENT_CHECK=1 || PAYMENT_CHECK=0
DLIM

NLPRINT
DLIM
PRINT "Finding DB Server Details"
DLIM
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

exit
echo ${FINAL} | xargs -n1 | grep catalogue
if [ $? -ne 0 ]; then
  EXIT "RoboShop Product will need to display the products, Products will be displayed from the \e[1;35mCatalogue\e[0m Component\nConfiguration releated to catalogue does not exist.\nHence Exiting"
fi

# Grab Catalogue IP
IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep -i $component  | awk -F : '{print $(NF-1)}' | sed -e 's|//||')

# MongoDB is a dependency to catalogue hence moving towards finding the information of MongoBD

  exit

  DLIM
  echo -e "\e[1m Checking $component - \e[0m"
  DLIM1
  echo -e "Grabbing IP Address of $component"
  IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep -i $component  | awk -F : '{print $(NF-1)}' | sed -e 's|//||')
  wB "IP = ${IP}"
  CHECK_CONNECTION
  scp $(dirname $0)/functions $IP:/tmp/functions &>>${LOG}
  scp $(dirname $0)/$component.bash $IP:/tmp/$component.bash &>>${LOG}
  ssh -t $IP "bash /tmp/$component.bash" 2>>${LOG}




























exit

## Cases
RHEAD() {
  echo -e "\n\e[1m Following are the possible mistakes that you have done\e[0m"
}
R1() {
  echo -e "  \e[1;35m->\e[0m Check whether the IP address of the $component"
}
R2() {
  echo -e "  \e[1;35m->\e[0m Check whether the Server of the $component is Up and Running in AWS Portal"
}
R3() {
  echo -e "  \e[1;35m->\e[0m Check whether the Server of the $component has opened all the ports or not"
}

## Report Configuration





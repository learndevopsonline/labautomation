#!/bin/bash

source $(dirname $0)/functions

echo -e "\n\n\e[1;33m This script helps you to Check the Issues of RoboShop\e[0m"
echo -e "\e[1m Note: This script is still under development and does not have all the cases ready yet.\e[0m"

echo -e "\nThis script runs only in FRONTEND, Hence if you are sure that you are \nrunning under frontend server then proceed.."
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
DLIM
echo -e "\e[1m Checking Nginx Configuration\e[0m"
DLIM1
for component in cart catalogue user shipping payment ; do
  [ "$component" == "cart" -o "$component" == "user" ] && TAB="\t"
  echo -n -e "Checking $component Config.. \t${TAB}"
  OUT=$(grep $component /etc/nginx/default.d/roboshop.conf | xargs -n1 | grep ^http | awk -F '[:,/]' '{print $4}')
  if [ "$OUT" != "localhost" ]; then
    echo -e "\e[1;32m Config Found\e[0m - \e[1m Will Check Further for this component\e[0m"
    FINAL="$FINAL $component"
  else
    echo -e "\e[1;31m Config Not Found\e[0m - \e[1m Will Not Check Further for this component\e[0m"
  fi
  unset TAB
done

for component in ${FINAL}; do
  DLIM
  echo -e "\e[1m Checking $component - \e[0m"
  DLIM1
  echo -e "Grabbing IP Address of $component"
  IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep -i $component  | awk -F : '{print $(NF-1)}' | sed -e 's|//||')
  wB "IP = ${IP}"
  CHECK_CONNECTION
  scp $(dirname $0)/functions $IP:/tmp/functions &>>${LOG}
  scp $(dirname $0)/$component.bash $IP:/tmp/$component.bash &>>${LOG}
  ssh -t $IP "bash /tmp/$component.bash"
done

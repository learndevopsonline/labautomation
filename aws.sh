#!/bin/bash

echo -e "\n\e[1;33m You can find all the scripts in following location\e[0m\nhttps://github.com/linuxautomations/labautomation/tree/master/aws\n"

curl -s "https://raw.githubusercontent.com/linuxautomations/scripts/master/common-functions.sh" >/tmp/common-functions.sh
#source /root/scripts/common-functions.sh
source /tmp/common-functions.sh

if [ ! -d /tmp/labautomation  ]; then
	git clone https://github.com/linuxautomations/labautomation.git /tmp/labautomation &>/dev/null
else
	cd /tmp/labautomation
	git stash &>/dev/null
	git pull &>/dev/null
fi

echo -e "${Y}>>>>> Select a AWS Operation to Perform${N}"
export PS3="Select Action> "
select action in `ls -1 /tmp/labautomation/aws | sed -e 's/.sh$//'`; do
		echo -e "\e[1;33m★★★ Performing $action ★★★\e[0m"
		sh /tmp/labautomation/aws/$action.sh
		break
done

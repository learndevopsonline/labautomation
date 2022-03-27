#!/bin/bash

echo -e "\n\e[1;33m You can find all the scripts in following location\e[0m\nhttps://github.com/linuxautomations/labautomation/tree/master/tools\n"

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

echo -e "${Y}>>>>> Select a TOOL to Install${N}"

bash /tmp/labautomation/devopsmenu
echo -e "💡 \e[1m You can choose number or tool name\e[0m"
read - 'Select Tool> ' tool
SCRIPT_NO=$(ls /tmp/labautomation/tools/$tool/*.sh |wc -l)
echo $SCRIPT_NO
if [ ! -f /tmp/labautomation/tools/$tool/install.sh ]; then
  echo -e "\e[1;31m No Install Script Found \e[0m"
  exit 1
fi

exit
	SCRIPT_NO=$(ls /tmp/labautomation/tools/$tool/*.sh |wc -l)
	case $SCRIPT_NO in
		1)
			echo -e "\e[1;33m★★★ Installing $tool ★★★\e[0m"
			sh /tmp/labautomation/tools/$tool/install.sh
			;;
		0)
			echo -e "No Install Script Found"
			exit 1
			;;
		*)
			echo -e "\e[31m Found Multiple Scripts, Choose One.. "
			select script in `ls -1 /tmp/labautomation/tools/$tool/*.sh | awk -F / '{print $NF}'`; do
				echo -e "\e[1;33m★★★ Installing $tool ★★★\e[0m"
				sh /tmp/labautomation/tools/$tool/$script
				break
			done
			;;
		esac
		break

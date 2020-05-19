#!/bin/bash

curl -s "https://raw.githubusercontent.com/linuxautomations/scripts/master/common-functions.sh" >/tmp/common-functions.sh
#source /root/scripts/common-functions.sh
source /tmp/common-functions.sh

if [ ! -d /tmp/labauto  ]; then 
	git clone https://github.com/linuxautomations/labautomation.git /tmp/labauto &>/dev/null
else 
	cd /tmp/labauto 
	git pull &>/dev/null
fi 

echo -e "${Y}>>>>> Select a TOOL to Install${N}"
export PS3="Select Tool> "
select tool in `ls -1 /tmp/labauto/tools`; do 
	SCRIPT_NO=$(ls /tmp/labauto/tools/$tool |wc -l)
	echo $SCRIPT_NO
done
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

echo ">>>>> Select a TOOL to Install"
export PS3="Select Tool> "
select tool in `ls -1 /tmp/labauto/tools`; do 
	echo Hai
done
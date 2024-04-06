#!/bin/bash

## Source Common Functions
source /tmp/labautomation/dry/common-functions.sh

## Checking Root User or not.
CheckRoot

## Checking SELINUX Enabled or not.
CheckSELinux

## Checking Firewall on the Server.
CheckFirewall


which java &>/dev/null
if [ $? -ne 0 ]; then
	## Downloading Java
	## DownloadJava 8
	## Installing Java
	## yum install /opt/jdk* -y &>/dev/null
	yum install java wget -y &>/dev/null
	if [ $? -eq 0 ]; then
		success "JAVA Installed Successfully"
	else
		error "JAVA Installation Failure!"
		exit 1
	fi
else
	success "Java already Installed"
fi

## Downloading Nexus
yum install https://kojipkgs.fedoraproject.org/packages/python-html2text/2016.9.19/1.el7/noarch/python2-html2text-2016.9.19-1.el7.noarch.rpm -y &>/dev/null
#URL=$(curl -L -s https://help.sonatype.com/display/NXRM3/Download+Archives+-+Repository+Manager+3 | html2text | grep tar.gz | sed -e 's/>//g' -e 's/<//g' | grep ^http|head -1 | awk '{print $1}')
URL="https://download.sonatype.com/nexus/3/nexus-3.64.0-04-unix.tar.gz"
NEXUSFILE=$(echo $URL | awk -F '/' '{print $NF}')
NEXUSDIR=$(echo $NEXUSFILE|sed -e 's/-unix.tar.gz//')
NEXUSFILE="/opt/$NEXUSFILE"
wget $URL -O $NEXUSFILE &>/dev/null
if [ $? -eq 0  ]; then
	success "NEXUS Downloaded Successfully"
else
	error "NEXUS Downloading Failure"
	exit 1
fi

## Adding Nexus User
id nexus &>/dev/null
if [ $? -ne  0 ]; then
	useradd nexus
	if [ $? -eq 0 ]; then
		success "Added NEXUS User Successfully"
	else
		error "Adding NEXUS User Failure"
		exit 1
	fi
fi

## Extracting Nexus
if [ ! -f "/home/nexus/$NEXUSDIR" ]; then
su nexus <<EOF
cd /home/nexus
tar xf $NEXUSFILE
EOF
fi
success "Extracted NEXUS Successfully"
## Setting Nexus starup
unlink /etc/init.d/nexus &>/dev/null
ln -s /home/nexus/$NEXUSDIR/bin/nexus /etc/init.d/nexus
echo "run_as_user=nexus" >/home/nexus/$NEXUSDIR/bin/nexus.rc
CONFIG_FILE=$(find /home/nexus/ -name nexus-default.properties)
sed -i -e '/nexus.scripts.allowCreation/ d' $CONFIG_FILE
sed -i -e '$ a nexus.scripts.allowCreation=true' $CONFIG_FILE
pip3 install nexus3-cli &>/tmp/nexus-install.log
success "Updating System Configuration"
systemctl enable nexus &>/dev/null
systemctl start nexus
if [ $? -eq 0 ]; then
	success "Starting Nexus Service"
else
	error "Starting Nexus Failed"
	exit 1
fi





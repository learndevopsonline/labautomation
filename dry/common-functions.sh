#!/bin/bash

## Colors
R="\e[31m"
B="\e[34m"
Y="\e[33m"
G="\e[32m"
BU="\e[1;4m"
BD="\e[1m"
BLU="\e[1;34m"
U="\e[4m"
IU="\e[7m"
LU="\e[2m"
N="\e[0m"

#ELV=$(rpm -q basesystem |sed -e 's/\./ /g' |xargs -n 1|grep ^el)
ELV=$(rpm -qi basesystem | grep Release  | awk -F . '{print $NF}')
export OSVENDOR=$(rpm -qi basesystem  | grep Vendor | awk -F : '{print $NF}' | sed -e 's/^ //')

## Common Functions

### Print Functions
hint() {
	echo -e "➜  Hint: $1$N"
}
export -f hint

hintt() {
	echo -e "\t\e[1;36m ➜  Hint:\e[0m\e[1m $1$N"
}
export -f hint

info() {
	echo -e " $1$N"
}
export -f info

Info() {
	echo -e "➜ INFO: $1$N"
}
export -f Info

Infot() {
	echo -e "\t➜ INFO: $1$N"
}
export -f Infot

warning() {
	echo -e "${Y}☑  $1$N "
}
export -f warning

warningt() {
	echo -e "\t${Y}☑  $1$N "
}

success() {
	echo -e "${G}✓  $1$N"
}
export -f success

successn() {
	echo -e "\n${G}✓  $1$N"
}
export -f successn

successt() {
	echo -e "\t${G}✓  $1$N"
}
export -f successt

error() {
	echo -e "${R}✗  $1$N"
}
export -f error

errorn() {
	echo -e "\n${R}✗  $1$N"
}
export -f errorn

errort() {
	echo -e "\t${R}✗  $1$N"
}
export -f errort

head_bu() {
	echo -e "  $BU$1$N\n"
}
export -f head_bu

head_u() {
	echo -e "  $U$1$N\n"
}
export -f head_u

head_iu() {
	echo -e "  \t$IU$1$N\n"
}
export -f head_iu

head_lu() {
	echo -e "  $LU$1$N\n"
}
export -f head_lu


### Checking Root User or not
CheckRoot() {
LID=$(id -u)
if [ $LID -ne 0 ]; then
	error "Your must be a root user to perform this command.."
	exit 1
fi
}

export -f CheckRoot

### Checking SELINUX
CheckSELinux() {
	STATUS=$(sestatus | grep 'SELinux status:'| awk '{print $NF}')
	if [ "$STATUS" != 'disabled' ]; then
		error "SELINUX Enabled on the server, Hence cannot proceed. Please Disable it and run again.!!"
		exit 1
	fi
}
export -f CheckSELinux

CheckFirewall() {

#	case $ELV in
#		el7|el8)
#			systemctl disable firewalld &>/dev/null
#			systemctl stop firewalld &>/dev/null
#		;;
#		*)  error "OS Version not supported"
#			exit 1
#		;;
#	esac
	success "Disabled FIREWALL Successfully"
}
export -f CheckFirewall

DownloadJava() {
	which java &>/dev/null
	if [ $? -eq 0  ]; then
		success "Java already Installed"
		return
	fi
	case $1 in
		8)
			curl -s https://raw.githubusercontent.com/learndevopsonline/scripts/master/java-params >/tmp/java-params
			source /tmp/java-params
			#BASE_URL8=http://download.oracle.com/otn-pub/java/jdk/$RELEASE/$SESSION_ID/$VERSION
			JDK_VERSION=`echo $BASE_URL_8 | rev | cut -d "/" -f1 | rev`
			platform="-linux-x64.rpm"
			JAVAFILE="/opt/$VERSION$platform"
			wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie"  "${BASE_URL}${platform}" -O $JAVAFILE &>/dev/null
			if [ $? -ne 0 ]; then
				error "Downloading JAVA Failed!"
				exit 1
			else
				success "Downloaded JAVA Successfully"
			fi
		;;
	esac
}
export -f DownloadJava

### Enable EPEL repository.

EnableEPEL() {
	case $ELV in
		el7)
			yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &>/dev/null
		;;
		*)  error "OS Version not supported"
			exit 1
		;;
	esac
	success "Configured EPEL repository Successfully"
}
export -f EnableEPEL

### Enable Docker Repository
DockerCERepo() {
	wget https://download.docker.com/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo &>/dev/null
	if [ $? -eq 0 ]; then
		yum makecache fast -y &>/dev/null
		success "Enabled Docker CE Repository Successfully"
	else
		error "Setting up docker repository failed"
		info "Try Manually .. Ref Guide : https://docs.docker.com/engine/installation/linux/docker-ce/centos/"
		exit 1
	fi
}
export -f DockerCERepo

Split() {
	HEADING=$2
	echo -e "\n\n===================================================================================================" >>$1
	echo -e "\t\t\t\e[31m$HEADING\e[0m" >>$1
	echo -e "===================================================================================================\n\n" >>$1
}
export -f Split

Stat() {
	if [ $1 -eq 0 ] ; then
		success "$2"
	elif [ $1 = "SKIP" ]; then
		warning "$2"
	else
		error "$2"
		exit 1
	fi
	if [ ! -z "$LOG" ]; then
		Split $LOG "$2"
	fi
}
export -f Stat

## Status print rather than failing
StatP() {
	if [ $1 -eq 0 ] ; then
		successn "$2 - OK"
	elif [ $1 = "SKIP" ]; then
		warningn "$2"
	else
		error "$2 - ERROR"
		[ "${StatP}" == 1 ] && exit 1 || EXIT=0
	fi
	return $1
}
export -f Stat

Statt() {
	if [ $1 -eq 0 ] ; then
		successt "$2"
	elif [ $1 = "SKIP" ]; then
		warningt "$2"
	else
		errort "$2"
		exit 1
	fi
	if [ ! -z "$LOG" ]; then
		Split $LOG "$2"
	fi
}
export -f Statt

CheckOS() {
  OSVER=$(rpm -qi basesystem | grep ^Release | awk '{print $NF}' | awk -F . '{print $1}')
  case $1 in
     7)
     	if [ $OSVER -eq 7 ]; then
		return 0
     	elif [ $OSVER -ne 7 ]; then
		error "Unsupported Opearating System... Expecting CentOS 7.x"
		exit 1
	fi
  esac
}
export -f CheckOS

PrintCenter() {
  TEXT=$1
  IFS=$','
  length=0
  for title in $TEXT; do
    l=${#title}
    if [ $length -lt $l ]; then
       length=$l
    fi
  done
  length=$(($length+4))
  header=$(while [ $length -gt 0 ]; do echo '*';length=$(($length-1));done|xargs |sed -e 's/ //g')
  COLUMNS=$(tput cols)
  printf "%*s\n" $(((${#header}+$COLUMNS)/2)) "$header"
  for title in $TEXT ; do
    printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
  done
  printf "%*s\n" $(((${#header}+$COLUMNS)/2)) "$header"
}
export -f PrintCenter

#

chatgpt_print() {
  echo -e "\e[1m"
  for word in $@ ; do

    echo -en "$word "
    sleep 0.2
  done
  echo
}

export -f chatgpt_print

command_print() {
  echo -e "\n\e[0mRunning the following command now.\n"
  echo -e "#️⃣ \e[36m $1 \e[0m"
  echo
}

export -f command_print



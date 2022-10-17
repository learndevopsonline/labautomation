#!/bin/bash

## Colors
R="\e[31m"
B="\e[34m"
Y="\e[33m"
G="\e[32m"
BU="\e[1;4m"
U="\e[4m"
IU="\e[7m"
LU="\e[2m"
N="\e[0m"

ELV=$(rpm -q basesystem |sed -e 's/\./ /g' |xargs -n 1|grep ^el)

## Common Functions

### Print Functions
hint() {
	echo -e "➜  Hint: $1$N"
}
info() {
	echo -e " $1$N"
}
Info() {
	echo -e "➜ INFO: $1$N"
}
Infot() {
	echo -e "\t➜ INFO: $1$N"
}
warning() {
	echo -e "${Y}☑  $1$N "
}
warningt() {
	echo -e "\t${Y}☑  $1$N "
}
success() {
	echo -e "${G}✓  $1$N"
}
successt() {
	echo -e "\t${G}✓  $1$N"
}
error() {
	echo -e "${R}✗  $1$N"
}
errort() {
	echo -e "\t${R}✗  $1$N"
}
head_bu() {
	echo -e "  $BU$1$N\n"
}

head_u() {
	echo -e "  $U$1$N\n"
}

head_iu() {
	echo -e "  \t$IU$1$N\n"
}

head_lu() {
	echo -e "  $LU$1$N\n"
}

### Checking Root User or not
CheckRoot() {
LID=$(id -u)
if [ $LID -ne 0 ]; then
	error "Your must be a root user to perform this command.."
	exit 1
fi
}

### Checking SELINUX
CheckSELinux() {
	STATUS=$(sestatus | grep 'SELinux status:'| awk '{print $NF}')
	if [ "$STATUS" != 'disabled' ]; then
		error "SELINUX Enabled on the server, Hence cannot proceed. Please Disable it and run again.!!"
		hint "Probably you can run the following script to disable SELINUX"
		info "  curl -s https://raw.githubusercontent.com/indexit-devops/caput/master/vminit.sh | sudo bash"
		exit 1
	fi
}

CheckFirewall() {

	case $ELV in
		el7|el8)
			systemctl disable firewalld &>/dev/null
			systemctl stop firewalld &>/dev/null
		;;
		*)  error "OS Version not supported"
			exit 1
		;;
	esac
	success "Disabled FIREWALL Successfully"
}

DownloadJava() {
	which java &>/dev/null
	if [ $? -eq 0  ]; then
		success "Java already Installed"
		return
	fi
	case $1 in
		8)
			curl -s https://raw.githubusercontent.com/linuxautomations/scripts/master/java-params >/tmp/java-params
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

Split() {
	HEADING=$2
	echo -e "\n\n===================================================================================================" >>$1
	echo -e "\t\t\t\e[31m$HEADING\e[0m" >>$1
	echo -e "===================================================================================================\n\n" >>$1
}

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

CheckVendor() {
  export OSVENDOR=$(rpm -qi basesystem | grep ^Vendor | awk '{print $NF}')
}

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


#

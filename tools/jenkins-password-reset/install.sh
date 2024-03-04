source /tmp/labautomation/dry/common-functions.sh

# Is Jenkins Running
systemctl status jenkins &>/dev/null
if [ $? -ne 0 ]; then
  		error "Jenkins Not Running"
  		exit 1
fi

sed -i -e '/useSecurity/ s/true/false/' /var/lib/jenkins/config.xml
systemctl restart jenkins
success "Restarted Jenkins"

read -p 'Do you want to rever the change? [Y/n]: ' ans

if [ -z "$ans" -o "$ans" == "n*" ]; then
  exit
fi

sed -i -e '/useSecurity/ s/false/true/' /var/lib/jenkins/config.xml
systemctl restart jenkins
success "Restarted Jenkins"

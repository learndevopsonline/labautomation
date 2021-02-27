```
Command History 
-------------------------------
    1  echo '[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc' >/etc/yum.repos.d/az.repo
    2  yum install azure-cli libicu -y
    3  az extension add --name azure-devops
    4  pip3 install pip --upgrade
    5  /usr/bin/python3 -m pip install keyring~=17.1.1 --target /root/.azure/cliextensions/azure-devops  --disable-pip-version-check --no-cache-dir
    6  echo xxxxxxxxxxxxxxxxxxxxxxxxx | az devops login
    7  su - centos
    8  history
```

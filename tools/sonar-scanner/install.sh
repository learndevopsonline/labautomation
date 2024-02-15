#!/bin/bash 

cd /opt
rm -rf sonar*
curl -O https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
unzip sonar-scanner-cli-5.0.1.3006-linux.zip
mv sonar-scanner-5.0.1.3006-linux sonar
ln -s /opt/sonar/bin/sonar-scanner /bin/sonar-scanner 
rm -f *.zip

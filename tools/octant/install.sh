#!/bin/bash 

VERSION=$(curl -s https://github.com/vmware-tanzu/octant/releases | grep Linux-64bit.tar.gz | xargs -n 1 | grep ^href | head -1 | sed -e 's/href=//')
DIRPATH=$(echo $VERSION | awk -F / '{print $NF}' | sed -e 's/.tar.gz//')
URL="https://github.com$VERSION"
curl -L -s -o /tmp/octant.tgz  $URL 
cd /tmp 
tar -xf octant.tgz
mv $DIRPATH/octant /bin 

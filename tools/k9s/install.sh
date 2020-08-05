#!/bin/bash 

cd /tmp
curl -L https://github.com/derailed/k9s/releases/download/$(curl -s https://github.com/derailed/k9s/releases | grep 'Release v' | head -1 | sed -e 's|<h1>||' -e 's|</h1>||' | awk '{print $2}')/k9s_Linux_x86_64.tar.gz | tar -xz
mv k9s /bin

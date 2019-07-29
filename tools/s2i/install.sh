#!/bin/bash

VERSION=$(curl -s https://github.com/openshift/source-to-image/tags  | grep tar.gz | grep nofollow  | head -1   | awk '{print $(NF-1)}' |sed -e 's/\// /g' |xargs -n1 |xargs -n1| grep tar.gz |sed -e 's/.tar.gz//' -e 's/^v//')
URL=$(curl -s https://github.com/openshift/source-to-image/releases/tag/v$VERSION | grep linux-amd64.tar.gz  | grep nofollow | awk -F = '{print $2}' |xargs -n1  | grep tar.gz)

cd /bin
wget -q https://github.com/$URL -O - | tar -xz

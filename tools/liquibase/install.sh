#!/bin/bash

VERSION=$(curl -s -L https://github.com/liquibase/liquibase/tags | grep 'id="toggle-commit-' | head -1  | xargs -n 1  | grep 'id=toggle-commit-' | awk -F - '{print $NF}' | sed -e 's/v//')

yum install java-11-openjdk -y
cd /tmp/
curl -s -L -O https://github.com/liquibase/liquibase/releases/download/v$VERSION/liquibase-$VERSION.tar.gz
rm -rf /opt/liquibase
mkdir -p /opt/liquibase
cd /opt/liquibase
tar -xf /tmp/liquibase-$VERSION.tar.gz ; rm -f liquibase-$VERSION.tar.gz


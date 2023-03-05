#!/bin/bash

VERSION=$(curl -s -L https://github.com/liquibase/liquibase/tags | grep 'id="toggle-commit-' | head -1  | xargs -n 1  | grep 'id=toggle-commit-' | awk -F - '{print $NF}' | sed -e 's/v//')

cd /tmp/
curl -L -O https://github.com/liquibase/liquibase/releases/download/v$VERSION/liquibase-$VERSION.tar.gz


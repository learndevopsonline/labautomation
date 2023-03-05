#!/bin/bash

VERSION=$(curl -s -L https://github.com/liquibase/liquibase/tags | grep 'id="toggle-commit-' | head -1  | xargs -n 1  | grep 'id=toggle-commit-' | awk -F - '{print $NF}')
JUST_VERSION=$(echo $VERSION | sed -e 's/v//')

echo $VERSION - $JUST_VERSION

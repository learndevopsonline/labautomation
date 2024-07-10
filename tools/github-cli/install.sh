#!/bin/bash

gh repo list
if [ $? -ne 0 ]; then
  curl -L https://cli.github.com/packages/rpm/gh-cli.repo >/etc/yum.repos.d/gh.repo
  yum install gh -y
  gh auth login && gh repo list
  gh auth refresh -h github.com -s admin:org
fi




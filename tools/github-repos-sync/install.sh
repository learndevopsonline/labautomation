#!/bin/bash

type gh &>/dev/null

if [ $? -ne 0 ]; then
  sudo labauto github-cli
fi

mkdir -p /opt/github-repos
cd /opt/github-repos

for repo in `gh repo list | grep -Ev '^Showing|^$' | awk '{print $1}' | awk -F / '{print $2}'`; do

  if [ ! -d "$repo" ]; then
    gh repo clone $repo
    continue
  fi

  cd $repo
  git pull
  cd ..
done

sed -i -e '/alias cfr/ d' /etc/environment
echo 'alias cfr="git add -A ; git commit -m "Changes from Raghu"; git push' >>/etc/environment

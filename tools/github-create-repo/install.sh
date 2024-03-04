#!/bin/bash

type gh &>/dev/null
if [ $? -ne 0 ]; then
  curl -L https://cli.github.com/packages/rpm/gh-cli.repo >/etc/yum.repos.d/gh.repo
  yum install gh -y
fi

gh repo list &>/dev/null
if [ $? -ne 0 ]; then
  gh auth login && gh repo list
fi

read -p 'Enter repository name / file : ' repos

if [ -f "$repos" ]; then
  CDIR=$(pwd)

  for name in $(cat $repos) ; do
  rm -rf /tmp/local
  mkdir /tmp/local
  cd /tmp/local
  echo "# $name" >README.md
  git init
  git branch -m main
  git add -A
  git commit -m INIT
  gh repo create $name --public  --source=. --push

  done
  exit
fi

CDIR=$(pwd)

for name in ${repos} ; do
rm -rf /tmp/local
mkdir /tmp/local
cd /tmp/local
echo "# $name" >README.md
git init
git branch -m main
git add -A
git commit -m INIT
gh repo create $name --public  --source=. --push

done


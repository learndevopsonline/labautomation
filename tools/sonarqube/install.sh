#!/bin/bash 


URL=$(curl -s https://www.sonarqube.org/downloads/ | grep 'Community Edition' | head -1  | xargs -n 1  | grep ^href | awk -F = '{print $2}')

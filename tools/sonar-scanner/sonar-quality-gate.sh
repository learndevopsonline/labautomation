#!/bin/bash 

USERNAME=$1
PASSWORD=$2
HOSTIP=$3
ID=$4 
KEY=$5

STATUS=$(curl -u "$USERNAME:$PASSWORD" "http://${HOSTIP}:9000/api/qualitygates/project_status?analysesId=${ID}&projectKey=${KEY}" | jq  '.projectStatus.status' | xargs)
if [ "$STATUS" == "OK" ]; then 
  exit 0
else 
  exit 1
fi

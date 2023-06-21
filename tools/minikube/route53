NAME=$(aws route53 list-hosted-zones --max-items 1 | jq '.HostedZones[].Name' |xargs)
jq -n --arg foobaz $NAME '{"id":$foobaz}'

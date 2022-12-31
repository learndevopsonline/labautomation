aws route53 list-hosted-zones --query "HostedZones[*].{ID:Id,Name:Name,Private:Config.PrivateZone}" --output table

echo -n -e "\e[1;33mEnter HostedZone ID\e[0m: "
read -p '' hosted_zone_id


aws route53 list-resource-record-sets --hosted-zone-id ${hosted_zone_id} --query "ResourceRecordSets[*].{Name:Name,Type:Type,Value:ResourceRecords[0].Value}" --output table --max-items 500




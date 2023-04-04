aws ec2   describe-security-groups --query "SecurityGroups[*].{ID:GroupId, Name: GroupName}" --output table

read -p 'Enter security group ID: ' id

aws ec2 describe-security-group-rules --filter Name="group-id",Values="${id}" --query "SecurityGroupRules[*].{from: FromPort, to: ToPort, cidr:CidrIpv4,ingress: IsEgress}" --output table

aws ec2   describe-security-groups --query "SecurityGroups[*].{ID:GroupId, Name: GroupName}" --output table

read -p 'Enter security group ID: ' id

aws ec2 describe-security-groups --group-ids ${id} --output json
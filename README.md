# labautomation

```
 aws ec2 describe-instances --query "Reservations[*].Instances[*].{PublicIP:PrivateIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}"  --output table
 ```

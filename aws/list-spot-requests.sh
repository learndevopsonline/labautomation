aws ec2 describe-spot-instance-requests  --query "SpotInstanceRequests[*].{Name:Tags[?Key==\`Name\`]|[0].Value,ID:SpotInstanceRequestId,InstanceID:InstanceId,Status:Status.Code,Message:Status.Message}" --output table
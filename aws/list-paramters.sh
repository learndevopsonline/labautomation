aws ssm describe-parameters --query 'Parameters[].{Name: Name}' --output table

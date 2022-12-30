aws iam list-roles --query 'Roles[*].{Name:RoleName}' --output table

echo -e "Enter Role Name to Describe: "
read -p '' role_name

if [ -z "$role_name" ]; then
  exit
fi

aws iam get-role --role-name $role_name --output table


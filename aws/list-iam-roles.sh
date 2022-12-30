aws iam list-roles --query 'Roles[*].{Name:RoleName}' --output table

echo -n -e "\e[1;33mEnter Role Name to Describe\e[0m: "
read -p '' role_name

if [ -z "$role_name" ]; then
  exit
fi

echo "\e[1m ############### ROLE "
aws iam get-role --role-name $role_name | jq .

echo "\e[1m ############### ATTACHED POLICIES "
aws iam list-attached-role-policies --role-name $role_name | jq .





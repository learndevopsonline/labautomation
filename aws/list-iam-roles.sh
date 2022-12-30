aws iam list-roles --query 'Roles[*].{Name:RoleName}' --output table

echo -n -e "\e[1;33mEnter Role Name to Describe\e[0m: "
read -p '' role_name

if [ -z "$role_name" ]; then
  exit
fi

echo -e "\e[1m ############### ROLE "
aws iam get-role --role-name $role_name | jq .

echo -e "\e[1m ############### ATTACHED POLICIES "
aws iam list-attached-role-policies --role-name $role_name | jq .

echo -n -e "\e[1;33mEnter Policy ARN to Describe\e[0m: "
read -p '' policy_arn

if [ -z "$policy_arn" ]; then
  exit
fi

VER=$(aws iam get-policy --policy-arn  $policy_arn | jq .Policy.DefaultVersionId | sed -e 's/"//g')

echo -e "\e[1m ############### POLICY "
aws iam get-policy-version --policy-arn  $policy_arn --version-id $VER | jq .



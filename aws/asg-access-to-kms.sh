echo -e "\e[1;33m Reference Document\e[0m : https://docs.aws.amazon.com/autoscaling/ec2/userguide/key-policy-requirements-EBS-encryption.html"

## Get the KMS ID
KC=$(aws kms list-aliases | grep -E 'AliasName|AliasArn' | sed -e '/\/aws\// d' | grep AliasArn | wc -l)
if [ $KC -gt 1 ]; then
  echo "Multiple KMS Keys found, Existing..."
  echo "Manually run the command from the above given URL"
  exit 1
fi

if [ $KC -eq 0 ]; then
  echo "No KMS Keys found, Existing..."
  exit 1
fi

ALIAS=$(aws kms list-aliases | grep -E 'AliasName|AliasArn' | sed -e '/\/aws\// d' | grep AliasArn | awk '{print $2}' | sed -e 's/"//g' -e 's/,//g' | awk -F : '{print $NF}')
ARN=$(aws kms describe-key --key-id $ALIAS --query 'KeyMetadata.Arn' --output text)
ACCOUNT=$(aws sts get-caller-identity  --query 'Account' --output text)

aws kms create-grant --region us-east-1 --key-id $ARN --grantee-principal arn:aws:iam::$ACCOUNT:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling --operations "Encrypt" "Decrypt" "ReEncryptFrom" "ReEncryptTo" "GenerateDataKey" "GenerateDataKeyWithoutPlaintext" "DescribeKey" "CreateGrant"

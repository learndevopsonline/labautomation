echo -e "\e[1;33m Reference Document\e[0m : https://docs.aws.amazon.com/autoscaling/ec2/userguide/key-policy-requirements-EBS-encryption.html"

## Get the KMS ID
LIST=$(/usr/local/bin/aws kms list-aliases | grep -E 'AliasName|AliasArn' | sed -e '/\/aws\// d' | grep AliasArn  | sed -e 's/"/ /g' | xargs -n1 | grep ^arn)
for arn in $LIST ; do
  state=(aws kms describe-key --key-id $i --query 'KeyMetadata.KeyState')
  if [ "state" == "Enabled" ]; then
    keys="$keys $arn"
  fi
done
if [ "$(echo $keys | xargs -n1 |wc -l)" -gt 1 ]; then
  echo "Multiple KMS Keys found, Exiting..."
  echo "Manually run the command from the above given URL"
  exit 1
fi

if [ "$(echo $keys | xargs -n1 |wc -l)" -eq 0 ]; then
  echo "No KMS Keys found, Existing..."
  exit 1
fi

ARN=$(/usr/local/bin/aws kms describe-key --key-id $keys --query 'KeyMetadata.Arn' --output text)
ACCOUNT=$(/usr/local/bin/aws sts get-caller-identity  --query 'Account' --output text)

/usr/local/bin/aws kms create-grant --region us-east-1 --key-id $ARN --grantee-principal arn:aws:iam::$ACCOUNT:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling --operations "Encrypt" "Decrypt" "ReEncryptFrom" "ReEncryptTo" "GenerateDataKey" "GenerateDataKeyWithoutPlaintext" "DescribeKey" "CreateGrant"

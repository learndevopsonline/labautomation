REPOS=$(aws ecr describe-repositories --query 'repositories[].repositoryName' --output text)
for i in ${REPOS}; do
  echo $i $(aws ecr describe-images --repository-name $i --query 'imageDetails[].imageTags' --output text | xargs)
done

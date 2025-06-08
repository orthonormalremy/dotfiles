## 1. Connect to aws cli
can be done from 


aws ec2 describe-images \
    --owners 427812963091 \
    --region us-east-1 \
    --filter \
        'Name=name,Values=nixos/*' \
        'Name=architecture,Values=x86_64' \
    --query 'reverse(sort_by(Images, &CreationDate))[].[Name,ImageId,CreationDate]' \
    --output table




aws ec2 describe-images \
    --owners 427812963091 \
    --region us-east-1 \
    --filter \
        'Name=name,Values=nixos/*' \
        'Name=architecture,Values=x86_64' \
    --query 'reverse(sort_by(Images, &CreationDate))[0].ImageId'
    --output text
    --output table



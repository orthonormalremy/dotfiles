aws ec2 import-key-pair \
  --key-name "id_rsa" \
  --public-key-material fileb://~/.ssh/id_rsa.pub


aws ec2 describe-images \
    --owners 427812963091 \
    --region us-east-1 \
    --filter \
        'Name=name,Values=nixos/*' \
        'Name=architecture,Values=x86_64' \
    --query 'reverse(sort_by(Images, &CreationDate))[0].ImageId'
    --output text
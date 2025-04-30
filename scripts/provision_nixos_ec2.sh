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


aws ec2 create-security-group \
    --group-name "launch-wizard-2" \
    --description "launch-wizard-2 created 2025-04-29T23:51:03.877Z" \
    --vpc-id "vpc-0eabda5adf30acafd" 

aws ec2 authorize-security-group-ingress \
    --group-id "sg-preview-1" \
    --ip-permissions '{"IpProtocol":"tcp","FromPort":22,"ToPort":22,"IpRanges":[{"CidrIp":"15.248.1.206/32"}]}' 


aws ec2 run-instances \
    --image-id "ami-0ccb2c640cdb2ee19" \
    --instance-type "m7a.2xlarge" \
    --key-name "id_rsa" \
    --block-device-mappings '{"DeviceName":"/dev/xvda","Ebs":{"Encrypted":false,"DeleteOnTermination":true,"Iops":3000,"SnapshotId":"snap-00b099bde6384c6fb","VolumeSize":512,"VolumeType":"gp3","Throughput":125}}' \
    --network-interfaces '{"AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["sg-preview-1"]}' \
    --tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"nixos-srv-2"}]}' \
    --private-dns-name-options '{"HostnameType":"ip-name","EnableResourceNameDnsARecord":true,"EnableResourceNameDnsAAAARecord":false}' \
    --count "1" 
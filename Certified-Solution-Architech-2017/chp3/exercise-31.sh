#!/bin/bash
# Filename: exercise-31.sh
# Task: Launch and Connect to a Linux Instance

# Create a key pair 
aws ec2 create-key-pair --key-name AmzLinuxKey --query 'KeyMaterial' --output text > AmazonLinux.pem
chmod 400 AmazonLinux.pem
# Create Security Group
aws ec2 create-security-group --group-name LinuxGroup --description "For Linux Instances" 
# Add rules for SSH and HTTP access to security group
aws ec2 describe-security-groups --group-name LinuxGroup # Copy the security groupId
aws ec2 authorize-security-group-ingress --group-id sg-097302308e8550121 --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-097302308e8550121 --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-097302308e8550121 --protocol tcp --port 443 --cidr 0.0.0.0/0

# Launch the instance 
aws ec2 run-instances --image-id ami-078a289ddf4b09ae0 --count 1 --instance-type t2.micro --key-name AmzLinuxKey --security-group-ids sg-097302308e8550121 --tag-specifications 'ResourceType=instance,Tags=[{Key=env,Value=development}]' 'ResourceType=volume,Tags=[{Key=env,Value=development}]'

# SSH into the newly launched instance 
aws ec2 describe-instances # Copy the instance's public IP address
ssh -i AmazonLinux.pem ec2-user@18.133.223.17

# Terminate the instance 
aws ec2 terminate-instances --instance-id i-0e9bf8a47619bbe31
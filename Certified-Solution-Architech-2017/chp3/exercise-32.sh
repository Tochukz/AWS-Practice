#!/bin/bash
# Filename: exercise-32.sh
# Task: Launch a Windows Instance with Bootstrapping

# Create a key pair 
aws ec2 create-key-pair --key-name WinKey --query 'KeyMaterial' --output text > Win2019Key.pem

# Create Security Group
aws ec2 create-security-group --group-name WindowsGroup --description "For Windows Instances"

# Add rules for RDP and HTTP access to security group
aws ec2 describe-security-groups  --group-name WindowsGroup # Copy the security groupId
aws ec2 authorize-security-group-ingress --group-id sg-0160abe1548f006f2 --protocol tcp --port 3389 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-0160abe1548f006f2 --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-0160abe1548f006f2 --protocol tcp --port 443 --cidr 0.0.0.0/0

# Launch the instance 
aws ec2 run-instances --image-id ami-0fd22a016e4e785f1 --count 1 --instance-type t2.micro --key-name WinKey --security-group-id sg-0160abe1548f006f2  --user-data file://user-script.bat --tag-specification 'ResourceType=instance,Tags=[{Key=env,Value=development}]' 'ResourceType=volume,Tags=[{Key=env,Value=development}]'

# Retrieve and decrypt initial password 
aws ec2 get-password-data --instance-id i-07879503cb5d6c469 --priv-launch-key Win2019Key.pem

# User the instance public IP and the password obtained above to connect to the instance using windows Remote Desktop client 
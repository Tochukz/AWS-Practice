#!/bin/bash
# Filename: linux.sh
# Description: Lunch an EC2 Linux Instance

# Initialize Global Variable
source config.sh

## Lunch AWS Linux Instance
echo Lunching Instance 
echo Instance Type=$INSTANCE_TYPE
echo AMI=$AMI


# aws ec2 run-instances --image-id ami-xxxxxxxx \
#   --count 1 \
#   --instance-type t2.micro \
#   --key-name MyKeyPair \
#   --security-group-ids sg-xxxxxxxx \
#   --subnet-id subnet-xxxxxxxx \
#   --user-data file://lamp=stack.sh \
#   --region eu-west-2 \
#   --tag-specifications \
#   'ResourceType=instance,Tags=[{Key=webserver,Value=production}]' \
#   'ResourceType=volume,Tags=[{Key=cost-center,Value=cc123}]'

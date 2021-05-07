#!/bin/bash
# Filename: security.sh
# Description: Create Security Groups

source ./confif/network.config.sh

echo Creating Security Groups 
VPCId=$1
aws ec2 create-security-group --group-name $WEB_SECURITY_GROUP --description "Web Servers security group" --vpc-id $VPCId
aws ec2 create-security-group --group-name $DB_SECURITY_GROUP --description "DB Servers security group" --vpc-id $VPCId

echo Created Security Groups: $WEB_SECURITY_GROUP and $DB_SECURITY_GROUP

aws ec2 authorize-security-group-ingress --group-name $WEB_SECURITY_GROUP --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name $WEB_SECURITY_GROUP --protocol tcp --port 22 --cidr 0.0.0.0/0
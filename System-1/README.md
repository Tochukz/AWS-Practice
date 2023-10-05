## System-1 VPC Setup  
#### Setting up a VPC network for you project  
__Introduction__   
This system represents an arrangement that can be used for a typical web server application(s). For example, an online store.   
The system consists of a VPC with two subnets - a private and public subnet. One or more EC2 instances live in the public subnet.  
The instances in the public subnet will house the web servers. The other instances resided on the private subnet and will be used to house the database instance(s).   
__Note:__ AWS RDS is not used in this arrangement.

__Allocate an Elastic IP Address__   
Allocate an Elastic IP Address for your NAT gateway
```
aws ec2 allocate-address \
    --domain vpc \
    --network-border-group us-west-2-lax-1
```
See command details at [allocate-address](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/allocate-address.html)

__Create a VPC__   
```
$ aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 \
  --instance-type t2.micro --key-name MyKeyPair \
  --security-group-ids sg-xxxxxxxx --subnet-id subnet-xxxxxxxx \
  --user-data file://my_script.sh \
  --tag-specifications \
  'ResourceType=instance,Tags=[{Key=webserver,Value=production}]' \
  'ResourceType=volume,Tags=[{Key=cost-center,Value=cc123}]'
```
See command details at [create-vpc](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-vpc.html)  

__Create a Private subnet__   

__Create public subnet__   

__Lunch EC2 instance into the private subnet__   

__Lunch EC2 instance into the public subnet__   

__Create your Resources (EC2s/RDBs)__   
Use Consistent Tag names for you resources where the tag name(key) represents the environment and the value represent the resource. For example:

| Key               | Value           |
|-------------------|-----------------|
| production-server | server 1        |
| production-server | server 2        |  
| production-server | security-group1 |
| staging-server    | server 1        |
| staging-server    | security-group1 |

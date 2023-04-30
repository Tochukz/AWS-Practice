# To Configure an Application Load Balancer

### Configure VPC
Choose 2 or more availiability zones.  
Configure a VPC with at least 1 public subnet in each of the availability zones
```bash
$ aws ec2 create-vpc --cidr-block 172.16.0.0/16
# View all the availabilty zones in your region
$ aws ec2 describe-availability-zones
# Create 3 subnets in 2 availability zones
$ aws ec2 create-subnet --vpc-id vpc-092013fc89a378cc9 --cidr-block 172.16.0.0/18 --availability-zone eu-west-2a
$ aws ec2 create-subnet --vpc-id vpc-092013fc89a378cc9 --cidr-block 172.16.64.0/18 --availability-zone eu-west-2b
```

### Make the subnets public
```bash
# Create internet gateway and attach it to your VPC
$ aws ec2 create-internet-gateway
$ aws ec2 attach-internet-gateway --vpc-id vpc-092013fc89a378cc9 --internet-gateway-id igw-067c93547b91a574b

# Create route table and add route which allows all IPs
$ aws ec2 create-route-table --vpc-id vpc-092013fc89a378cc9
$ aws ec2 create-route --route-table-id rtb-044f68486f7fcd2c7 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-067c93547b91a574b
# To check that the route has been created
$ aws ec2 describe-route-tables --route-table-id  rtb-044f68486f7fcd2c7

# Associate the route table with the subnets
$ aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-092013fc89a378cc9" --query "Subnets[*].{ID:SubnetId,CIDR:CidrBlock}"
$ aws ec2 associate-route-table --subnet-id subnet-09eec1c1742a6de63 --route-table-id rtb-044f68486f7fcd2c7
$ aws ec2 associate-route-table --subnet-id subnet-0198feae23a88e950 --route-table-id rtb-044f68486f7fcd2c7

# Configure subnets to automatically assign IP address to EC2 instances launched in the subnet
$ aws ec2 modify-subnet-attribute --subnet-id subnet-09eec1c1742a6de63 --map-public-ip-on-launch
$ aws ec2 modify-subnet-attribute --subnet-id subnet-0198feae23a88e950 --map-public-ip-on-launch
```
These public subnets are used to configure the load balancer but the EC2 instances maybe on different subnets.

### Launch EC2 instances
Launch EC2 instances in each of your choosen availability zones.   
Install a web server like Nginx or IIS on each of the EC2 instances.  
```bash
# Create security group
$ aws ec2 create-security-group --vpc-id vpc-092013fc89a378cc9 --group-name "LinuxSecurityGroup" --description "Security group for linux instance"
$ aws ec2 authorize-security-group-ingress --group-id sg-012496343b1b2322a --protocol tcp --port 22 --cidr 0.0.0.0/0
$ aws ec2 authorize-security-group-ingress --group-id sg-012496343b1b2322a --protocol tcp --port 80 --cidr 0.0.0.0/0

# Launch instance 1 in subnet 1
$ aws ec2 run-instances --image-id ami-04706e771f950937f --count 1 --instance-type t2.micro --key-name AmzLinuxKey2 --security-group-ids sg-012496343b1b2322a --subnet-id subnet-09eec1c1742a6de63 --user-data file://bootscript.sh  
# Get the public IP address
$  aws ec2 describe-instances --instance-id i-06990e3f25687e29f

# Launch instance 2 in subnet 2
$ aws ec2 run-instances --image-id ami-04706e771f950937f --count 1 --instance-type t2.micro --key-name AmzLinuxKey2 --security-group-ids sg-012496343b1b2322a --subnet-id subnet-0198feae23a88e950 --user-data file://bootscript.sh  
# Get the public IP address
$  aws ec2 describe-instances --instance-id i-09df15816bff716bc
```

### Create the application load balancer
```bash
# create security group
$ aws ec2 create-security-group --vpc-id vpc-092013fc89a378cc9 --group-name WebSecurityGroup
$ aws ec2 authorize-security-group-ingress --group-id sg-00867da50bea1722e --protocol tcp --port 80 --cidr 0.0.0.0/0

# Create the load balancer
$ aws elbv2 create-load-balancer --name WebAppBalancer --subnets subnet-09eec1c1742a6de63 subnet-0198feae23a88e950 --security-group sg-00867da50bea1722e

# Create a target group
$ aws elbv2 create-target-group --name WebTargerGroup --protocol HTTP --port 80 --vpc-id vpc-092013fc89a378cc9 --ip-address-type ipv4

# Register your EC2 instances on the target group
$ aws elbv2 register-targets --target-group-arn arn:aws:elasticloadbalancing:eu-west-2:966727776968:targetgroup/WebTargerGroup/d58d39b323f79960 --targets Id=i-06990e3f25687e29f Id=i-09df15816bff716bc

# Create a listener
$ aws elbv2 create-listener --load-balancer-arn arn:aws:elasticloadbalancing:eu-west-2:966727776968:loadbalancer/app/WebAppBalancer/832c79f50807c7b9 --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:eu-west-2:966727776968:targetgroup/WebTargerGroup/d58d39b323f79960

# (optional) Check the health of the targets
$ aws elbv2 describe-target-health --target-group-arn arn:aws:elasticloadbalancing:eu-west-2:966727776968:targetgroup/WebTargerGroup/d58d39b323f79960

# Get the DNS Name of the load balancer. You can use it to access the websites with a browser
$ aws elbv2 describe-load-balancers
```

__To Add HTTPS listener__
1. Create or import a certificate using AWS Certificate Manager
2. Create a listener and specify an SSL certificate and optionally, an SSL policy
```bash
# Get your certificate's ARN
$ aws acm list-certificates
# Add the HTTPS listener
$ aws elbv2 create-listener --load-balancer-arn arn:aws:elasticloadbalancing:eu-west-2:966727776968:loadbalancer/app/WebAppBalancer/832c79f50807c7b9 --protocol HTTPS --port 443 --certificates CertificateArn=arn:aws:acm:eu-west-2:966727776968:certificate/bb46bac2-b147-4475-9d61-18036ad684c4 --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:eu-west-2:966727776968:targetgroup/WebTargerGroup/d58d39b323f79960
```

__To revoke a security group ingress__
```
$ aws ec2 revoke-security-group-ingress --group-id sg-012496343b1b2322a --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 80, "ToPort": 80}]'
```

__To see the load balancer in action__  
1. Edit the default server index page `/usr/share/nginx/html` on EC2 instance-1 and add a background color to  the style element `background: lightblue;`.
2. Do the same for EC2 instance-2 but with a different color: `background: blue;`
3. Use the Load balancer DNS Name to visit the site on the browser.
4. Each time your refresh the page the background color of the page should change.

__To deregister an EC2 instances from a target group__  
```
$ aws elbv2 deregister-targets --target-group-arn arn:aws:elasticloadbalancing:eu-west-2:966727776968:targetgroup/WebTargerGroup/d58d39b323f79960 --targets Id=i-06990e3f25687e29f
```

### Enable HTTPS for your load balancer
This can be done with different outcomes:
1. If you need to pass encrypted traffic to targets without the load balancer decrypting it, you can create a Network Load Balancer or Classic Load Balancer with a TCP listener on port 443
2. If you are okay with the Load balancer decrypting the traffic, then you create an Application Load Balancer with a HTTPS listener.   

__Creact an HTTPS listener__  
1. Request for an SSL certificate using AWS Certificate Manager. See [Configure an SSL certificate on AWS](https://gist.github.com/Tochukz/e984d61236d74e5729d40e8afbf0671f#configure-an-ssl-certificate)  

2. Create the HTTPS listener.
```
$
```
3. Add EC2 targets to the listener
```
$ 
```

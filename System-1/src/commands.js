
const { VPC_CIDR, REGION } = process.env;

module.exports.createVPC = () => `aws ec2 create-vpc --cidr-block ${VPC_CIDR} --instance-tenancy default --tag-specifications ResourceType=vpc,Tags=[{Key=name,Value=chucks-auto-vpc}] --region ${REGION}`;

module.exports.createSubnet = (vpcID) => ``;

//module.exports.createVPC = `aws ec2 describe-vpcs --region eu-west-2`;
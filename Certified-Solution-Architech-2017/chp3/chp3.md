## Amazon Elastic Compute Cloud (EC2) and Amazon Elastic Block Store (EBS)

### Exercises
3.1) Launch and Connect to a Linux Instance


__Tips__  
To see list of available Instance Type, go the the EC2 console and under the "Instances" menu click on the "Instance Types" submenu.     
To see list of available AMIs, go to the EC2 console and under the "Image" menu click on the "AMI Catalog" submenu.    

__Test for open connection/port for EC2 instance__  
Using CMD 
```
> telnet 18.133.223.17 80
```  
Using Powershell  
```
> Test-NetConnection -ComputerName 18.133.223.17 -Port 80
```  
Note that for these test work, 
1. The port/IP address need to be allowed by the security group attached to the EC2 instance 
2. A service, such as Nginx for port 80, needs to be listening on the EC2 instance.  

__Useful Articles__  
* [Install MySQL on Amamzon Linux 2](https://techviewleo.com/how-to-install-mysql-8-on-amazon-linux-2/)   
* [Install PHP 8 on Amazon Linux 2](https://techviewleo.com/install-php-8-on-amazon-linux/)
* [Setup Virtual host on CentOS-7](https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-on-centos-7) 
* [Install LEMP on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-centos-7)  

__Useful Commands for LAMP stack installation on Amazon Linux__   
To see all the yum repositories using ls command  
```
ls -la /etc/yum.repos.d 
```
To see all the yum repositories using yum   
```
sudo yum repolist
```   
Test if Nginx configuration files are valid 
```
sudo nginx -t
```

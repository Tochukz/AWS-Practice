#!/bin/bash
# Filename: exercise-X1.sh
# Task: Install LAMP stack on Amazon Linux 2 EC2 instance

### Install the stack 
# Comfirm the OS release 
cat /etc/os-release
# Update OS packages
sudo yum update -y

## Install Nginx 
sudo amazon-linux-extras install nginx1 -y
# Start Nginx service
sudo service nginx start
# Enable Nginx to start at Boot time
sudo chkconfig nginx o

## Install MySQL
# Add MySQL Yum repository 
sudo yum install https://dev.mysql.com/get/mysql80-community-release-el7-5.noarch.rpm -y
sudo amazon-linux-extras install epel -y
sudo yum install mysql-community-server -y
# Start MySql Server
sudo systemctl enable --now mysqld
systemctl status mysqld
# Reveal temporary password 
sudo grep 'temporary password' /var/log/mysqld.log
# Run the secure-installation wizard 
sudo mysql_secure_installation -p
# Login to the Database 
mysql -uroot -p

## Install PHP 
# Add EPEL and Remi Repositories 
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
# Update Yum index to confirm the two reposiories are working 
sudo yum makecache
# Install yum-utils
sudo yum -y install yum-utils 
# Check for available Version on OS repository 
sudo amazon-linux-extras | grep php
# Enable the Repo 
sudo yum-config-manager --disable 'remi-php*'
sudo amazon-linux-extras enable php8.0
# Install PHP and standard extentions and PHP-FPM
sudo yum clean metadata
sudo yum -y install php-{pear,cgi,pdo,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip}
sudo yum install php-mysqlnd php-fpm

## Setup Visual host 
sudo mkdir /etc/nginx/sites-available
sudo mkdir /etc/nginx/sites-enabled
# Edit the /etc/nginx/nginx.conf file and add the lines at the end of the http {} block
# include /etc/nginx/sites-enabled/*.conf;
# server_names_hash_bucket_size 64;

# Setup website directory
sudo mkdir -p /var/www/k-medics.site/html
sudo chown -R $USER:$USER /var/www/k-medics.site/html
sudo chmod -R 755 /var/www

# Copy your website code from you local machine to the EC2 instance. 
scp -i AmazonLinux2.pem /c/laragon/www/kmedics/kmedics.zip ec2-user@18.130.204.88:/var/www/k-medics.site/html/kmedics.zip

# Unzip you code in the EC2 instance 
cd /var/www/k-medics.site/html
unzip kmedics.zip

# Configure server block on Nginx Config 
# Create the website config file, see kmedics.conf or sample.conf 
# Copy website config file from your local machine to the EC2 instance 
$ scp -i AmazonLinux2.pem /path/to/kmedics.conf ec2-user@18.130.204.88:~/kmedics.conf

# Copy website config in EC2 instance 
sudo cp ~/kmedics.conf /etc/nginx/sites-available/k-medics.site.conf 
# Enable the website 
sudo ln -s /etc/nginx/sites-available/k-medics.site.conf /etc/nginx/sites-enabled/k-medics.site.conf

# Update you host file: edit /etc/hosts file add the following mapping 
# 18.130.204.88  k-medics.site

## Introduction to AWS
### Install AWS CLI
__To install AWS CLI on Windows__  
1. Download the MSI installer from [awscli.amazonaws.com/AWSCLIV2.msi](https://awscli.amazonaws.com/AWSCLIV2.msi) and run the installer.   
Alternatively you can use the msiexe.exe command to install it directly from CMD window.
```
> msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
```  
2. After installation is complete, open a new CMD window and run the command to verify successfull installation.
```
> aws --version
```  

__To install AWS CLI on macOS__     
1. Download the required file using the `curl` command
```
$ curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
```
2. Run the standard macOS `installer` program specifiying the donwloded file from step 1.   
```
$ sudo installer -pkg ./AWSCLIV2.pkg -target /
```  
The file should be installed to `/usr/local/aws-cli`  and symlink automatically created in `/usr/local/bin`.  
3. Verify that the installation was successful.  
```
$ which aws
$ aws --version  
```
[Learn more](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)  

### Configure you AWS CLI   
1. Create an AWS User with programtic access  
* Go to the IAM Management console.  
* Create a new User and Grant him Administrative previlege.
* Make sure the select the programatic access checkbox.  
* Copy the geenrated `Access key ID` and `Secret access key`   

2. Run the `aws configure` command
```
> aws configure  
```  
Enter the relevant parameter when prompted  as follows:  
```
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json
```  
For Windows, your `credentials` and `config` file should be generated in `C:\Users\YouUser\.aws` folder.  
[Learn more](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html)  

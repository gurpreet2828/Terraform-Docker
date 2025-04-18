# Deploy Ghost Blog and MySQL with Docker and Terraform on AWS infrastructure

## Setup Overview

The document outlines the steps to deploy a Ghost Blog and MySQL using Docker, Docker Compose and Terraform on an AWS EC2 instance. Key tools include:

• Terraform: For infrastructure provisioning.

• Docker/Docker Compose: For application containerization.

• AWS CLI: For interaction with AWS services.

• vsCode: Code Editor

• Ubuntu Linux environment

• AWS account with access keys

### Troubleshooting and errors which I faced during this project implementation

**1.AWS CLI Configuration Problems:** If aws configure fails, verify that your AWS Access Key and Secret Key are correct.

Run aws configure and input your credentials

Confirm setup with aws sts get-caller-identity

**2.Permission Denied During SSH:** Ensure you're using the correct private key and the correct username (ec2-user).And ensure you're using the correct private key with the -i option.

Ex: ssh -i /path/to/your-key.pem ec2-user@98.80.171.157

ssh -i /root/.ssh/docker ec2-user@98.80.171.157

**3. Permissions Issues during git init**

Issue: Git init shows .git: Permission denied

Fix Permission

sudo chown -R administrator:administrator/home/administrator/Terraform-Docker

sudo chmod u+rwx /home/administrator/Terraform-Docker

**4.Terraform Plan Errors:** Check if the paths to private/public keys are correctly defined in the variables.tf file (under modules -compute - variables.tf)

Issue: Invalid SSH key path error like "C:\\Users\\wessa\\.ssh\\id_rsa.pub"

Fix: Update variables.tf to point to a valid Unix-style path, e.g. /root/.ssh/docker.pub

**5.Docker not running**

Sudo systemctl status docker

sudo systemctl start docker

sudo systemctl enable docker

docker run docker.io/hello-world: Run the hello-world container image to verify installation

6.	Ghost Blog Not Accessible via Public IP
Issue: Blog not loading in browser
Fix:
1.	Check running containers: docker ps
2.	Check not running containers: docker ps -a
3.	Run container: docker run ghost-blog
4.	View logs for errors: docker logs <container-name>
5.	Restart services: docker compose up -d
7.	Issue: Errors in docker-compose.yml syntax
Fix:
1.	Run docker compose config to validate
2.	Check for YAML syntax issues like incorrect indentation, colons, or missing values 
Step1: Transfer Terraform and yml files:
Use scp to transfer your Terraform and docker files from your local machine to your Ubuntu instance:
Note: Transfer the terraform and docker code from local machine to Linux by running following command on cmd 
scp -r -v "C:\Users\Gurpreet\OneDrive\Desktop\York Univ\Assignments\Assignment 4 - Docker\Terraform-Docker" administrator@10.0.0.83:/home/administrator
Enter your password of ubuntu user
 

It shows the following screen after transfer
 
Make git repo
administrator@Cloudinfotech-Server:~/Terraform-Docker$ git init
/home/administrator/Terraform-Docker/. git: Permission denied
 
Fix Permission
sudo chown -R administrator:administrator /home/administrator/Terraform-Docker
sudo chmod u+rwx /home/administrator/Terraform-Docker

Step2: Install Terraform on Ubuntu
1. Update and install dependencies
sudo apt update && sudo apt install -y gnupg software-properties-common curl
2. Add the HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
3. Add the HashiCorp repo
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list
4. Update and install Terraform
sudo apt update
sudo apt install terraform -y

5. Verify installation
terraform -v
 
Provisioning Infrastructure with Terraform
Step1: Terraform init
 

Step 2: Terraform fmt
Step 3: Terraform validate
 
Step 4: Terraform plan
 
After running the terraform plan if you see the above error than you need to configure aws account as it found no aws credentials
AWSCLI Install
To install the AWS CLI, run the following command
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

Run the following command to check if AWS CLI is installed correctly:
aws –version
You see the following output
 

Step 3: Create AWS account 
After Creating 
Click on account name - Select Security Credentials
 






Click Create access key.
 

Note: Download the key file or copy the Access Key ID & Secret Access Key (Secret Key is shown only once!).

After install and creating AWS account configure the AWS 
Configure AWS CLI with the New Access Key
aws configure
It will prompt you for:
1.	AWS Access Key ID: Your access key from AWS IAM.
2.	AWS Secret Access Key: Your secret key from AWS IAM.
3.	Default region name: (e.g., us-east-1, us-west-2).
4.	Default output format: (json, table, text — default is json).
Enter access key and secret key which you will get from aws account

Check credentials added to aws configure correctly
aws sts get-caller-identity
If your AWS CLI is properly configured, you'll see a response like this:

 

Run Terraform plan 
If it shows the following error
Error: Invalid function argument
│ 
│   on modules/compute/main.tf line 17, in resource "aws_key_pair" "aws-key":
│   17:   public_key = file(var.ssh_key_public)
│     ├────────────────
│     │ while calling file(path)
│     │ var.ssh_key_public is "C:\\Users\\wessa\\.ssh\\id_rsa.pub"
 
Then in this case you must update the location of public and private keys under modules -compute - variables.tf



As shown bellow in image

 

5: Terraform apply
Provision terraform managed infrastructure. You must confirm by trying yes if you would like to continue and perform the actions described to provision your infrastructure resources

 
If everything works fine at end you will see the public Ip

Step 4: Connect to EC2 instance 
ssh ec2-user@ 98.80.171.157
 
Ensure you're using the correct private key and the correct username (ec2-user) and ensure you're using the correct private key with the -i option.
Example
ssh -i /path/to/your-key.pem ec2-user@98.80.171.157
ssh -i /root/.ssh/docker ec2-user@98.80.171.157
you will see ec2 instance connected remotely with your ubuntu instance
 

Docker Install on EC2-instance
yum install docker -y
systemctl status docker
 

systemctl start docker
systemctl enable docker
 

docker run docker.io/hello-world

Run the hello-world container image to verify installation: 


 

Step 5: Docker Compose
Install docker compose
sudo yum install -y py-pip, python3-dev, libffi-dev, openssl-dev, gcc, libc-dev, rust, cargo, make

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

Check docker compose install
docker compose version
 

Create Docker Compose File
vi docker-compose,yml
copy and paste yml file 
for check it save properly
run
cat docker-compose.yml
If you're working with Docker Compose, you can validate your docker-compose.yml file by running:
docker compose config
if it shows some error as follows than there is syntax error in your yml file 
 

Correct the syntax and correct error of your yml file again run 
Docker compose config 
If it shows the full code than your yml file works fine
Start up the Docker Compose service: 

Run
docker compose up -d

Execute a compose up and use the detached flag to run the container in the background:
 

Verify that your app is up and running using the public IP address of your EC2 instance
 

Some important command of docker 
docker info
docker ps :  shows only running containers
 
Docker ps -a
It shows all the containers
 
Docker stop <container_name>: 
To stop the container
Docker rm <container_name> : 
To delete the container
Docker start <container_name>:
 to start the container
Docker search <image_name>
Ex: docker search ubuntu: it search all the images regarding ubuntu present on ubuntu hub
 
Docker exec -it <container_name>
To go inside the running docker


# Deploy Ghost Blog and MySQL with Docker and Terraform on AWS infrastructure

## Summary

This project involves deploying a Ghost Blog with a MySQL database using Docker, Docker Compose and Terraform on an AWS EC2 instance running Ubuntu.

The infrastructure is provisioned through Terraform, which automates the setup of the EC2 instance and SSH key configuration. Docker and Docker Compose are used to containerize and orchestrate the Ghost and MySQL services, enabling efficient application management. The AWS CLI is utilized for secure interaction with AWS services, while tools like VS Code and SCP assist in code transfer and editing.

During implementation, several issues were encountered and resolved, including AWS CLI configuration problems, SSH permission errors, Git initialization issues, and Docker service failures. Troubleshooting involved checking file permissions, correcting SSH key paths, installing necessary packages, and validating Docker Compose syntax. Successful deployment was verified through Terraform commands and by accessing the blog via the EC2 public IP. Key Docker commands were used to manage containers, ensuring the blog and database were running as expected.

## Setup Overview

The document outlines the steps to deploy a Ghost Blog and MySQL using Docker, Docker Compose and Terraform on an AWS EC2 instance. Key tools include:

**- Terraform:** For infrastructure provisioning.

**- Docker/Docker Compose:** For application containerization.

**- AWS CLI:** For interaction with AWS services.

**- vsCode:** Code Editor

**- Ubuntu Linux environment**

**- AWS account with access keys**

### Troubleshooting and errors which I faced during this project implementation

**1.AWS CLI Configuration Problems:** If aws configure fails, verify that your AWS Access Key and Secret Key are correct.

- Run aws configure and input your credentials

- Confirm setup with aws sts get-caller-identity

**2.Permission Denied During SSH:** Ensure you're using the correct private key and the correct username (ec2-user).And ensure you're using the correct private key with the -i option.

Ex: ssh -i /path/to/your-key.pem ec2-user@98.80.171.157

ssh -i /root/.ssh/docker ec2-user@98.80.171.157

**3. Permissions Issues during git init**

Issue: Git init shows .git: Permission denied

Fix Permission

- sudo chown -R administrator:administrator/home/administrator/Terraform-Docker

- sudo chmod u+rwx /home/administrator/Terraform-Docker

**4.Terraform Plan Errors:** Check if the paths to private/public keys are correctly defined in the variables.tf file (under modules -compute - variables.tf)

Issue: Invalid SSH key path error like "C:\\Users\\wessa\\.ssh\\id_rsa.pub"

Fix: Update variables.tf to point to a valid Unix-style path, e.g. /root/.ssh/docker.pub

**5.Docker not running**

- sudo systemctl status docker

- sudo systemctl start docker

- sudo systemctl enable docker

- docker run docker.io/hello-world: Run the hello-world container image to verify installation

**6.Ghost Blog Not Accessible via Public IP**

Issue: Blog not loading in browser

Fix:

**Check running containers:** docker ps

**Check not running containers:** docker ps -a

**Restart container:** docker start ghost-blog

**View logs for errors:** docker logs ghost-blog

**Restart services:** docker-compose up -d

**7. Issue: Errors in docker-compose.yml syntax**

Fix:

Run docker compose config to validate

Check for YAML syntax issues like incorrect indentation, colons, or missing values

**8.Access denied to files**
After transferring the files from windows to linux you need to give following permission so that we can save and edit files

sudo chown -R administrator:administrator /home/administrator/Terraform-Docker

sudo chmod -R u+rwX /home/administrator/Terraform-Docker

## Step1: Transfer Terraform and yml files

Use scp to transfer your Terraform and docker files from your local machine to your Ubuntu instance:

Note: Transfer the terraform and docker code from local machine to Linux by running following command on cmd 

scp -r -v "C:\Users\Gurpreet\OneDrive\Desktop\York Univ\Assignments\Assignment 4 - Docker\Terraform-Docker" administrator@10.0.0.83:/home/administrator

Enter your password of ubuntu user

![Image1](https://github.com/gurpreet2828/Terraform-Docker/blob/fe668ab95c2b25c233b90da636e62a15a3cf9b05/Images/Image1.png)

It shows the following screen after transfer

![Image2](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image2.png)

**Make git repo**

administrator@Cloudinfotech-Server:~/Terraform-Docker$ git init

/home/administrator/Terraform-Docker/. git: Permission denied

![Image3](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image3.png)

Fix Permission

sudo chown -R administrator:administrator /home/administrator/Terraform-Docker

sudo chmod u+rwx /home/administrator/Terraform-Docker

## Step2: Install Terraform on Ubuntu

**1.Update and install dependencies**

sudo apt update && sudo apt install -y gnupg software-properties-common curl

**2.Add the HashiCorp GPG key**

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

**3.Add the HashiCorp repo**

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \

sudo tee /etc/apt/sources.list.d/hashicorp.list

**4.Update and install Terraform**

sudo apt update

sudo apt install terraform -y

**5.Verify installation**

terraform -v

![Image5](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image5.png)

## Provisioning Infrastructure with Terraform

### Step1: Terraform init

![Image6](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image6.png)

### Step 2: Terraform fmt

### Step 3: Terraform validate

![Image7](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image7.png)

### Step 4: Terraform plan

After running the terraform plan if you see the above error than you need to configure aws account as it found no aws credentials

![Image8](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image8.png
)
### AWSCLI Install

To install the AWS CLI, run the following command

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

sudo ./aws/install

Run the following command to check if AWS CLI is installed correctly:

aws –version

You see the following output

![Image9](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image9.png)

## Step 3: Create AWS account

After Creating

Click on account name - Select Security Credentials

![Image27](https://github.com/gurpreet2828/Terraform-Docker/blob/fe668ab95c2b25c233b90da636e62a15a3cf9b05/Images/Image27.png)

Click Create access key.

![Image28](https://github.com/gurpreet2828/Terraform-Docker/blob/fe668ab95c2b25c233b90da636e62a15a3cf9b05/Images/Image28.png)

Note: Download the key file or copy the Access Key ID & Secret Access Key (Secret Key is shown only once!).

After install and creating AWS account configure the AWS

**Configure AWS CLI with the New Access Key**

aws configure

It will prompt you for:

**1.AWS Access Key ID:** Your access key from AWS IAM.

**2.AWS Secret Access Key:** Your secret key from AWS IAM.

**3.Default region name:** (e.g., us-east-1, us-west-2).

**4.Default output format:** (json, table, text — default is json).

Enter access key and secret key which you will get from aws account

Check credentials added to aws configure correctly

aws sts get-caller-identity

If your AWS CLI is properly configured, you'll see a response like this:

![Image10](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image10.png)

**Run Terraform plan**

If it shows the following error

![Image11](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image11.png)

Error: Invalid function argument

│   on modules/compute/main.tf line 17, in resource "aws_key_pair" "aws-key":
│   17:   public_key = file(var.ssh_key_public)
│     ├────────────────
│     │ while calling file(path)
│     │ var.ssh_key_public is "C:\\Users\\wessa\\.ssh\\id_rsa.pub"

Then in this case you must update the location of public and private keys under modules -compute - variables.tf

As shown bellow in image

![Image12](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image12.png)

### 5:Terraform apply

Provision terraform managed infrastructure. You must confirm by trying yes if you would like to continue and perform the actions described to provision your infrastructure resources

If everything works fine at end you will see the public Ip

![Image13](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image13.png)

## Step 4: Connect to EC2 instance

ssh ec2-user@ 98.80.171.157

![Image14](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image14.png
)
Ensure you're using the correct private key and the correct username (ec2-user) and ensure you're using the correct private key with the -i option.

Example

ssh -i /path/to/your-key.pem ec2-user@98.80.171.157

ssh -i /root/.ssh/docker ec2-user@98.80.171.157

you will see ec2 instance connected remotely with your ubuntu instance

![Image15](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image15.png)

### Docker Install on EC2-instance

yum install docker -y

systemctl status docker

systemctl start docker

systemctl enable docker

docker run docker.io/hello-world

Run the hello-world container image to verify installation:

![Image18](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image18.png)

## Step 5: Docker Compose

Install docker compose

sudo yum install -y py-pip, python3-dev, libffi-dev, openssl-dev, gcc, libc-dev, rust, cargo, make

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

Check docker compose install

**docker compose version**

![Image19](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image19.png)

**Create Docker Compose File**

vi docker-compose.yml

copy and paste yml file

for check it save properly

run

cat docker-compose.yml

![Image20](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image20.png)

If you're working with Docker Compose, you can validate your docker-compose.yml file by running:

docker compose config

if it shows some error as follows than there is syntax error in your yml file

![Image21](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image21.png)

Correct the syntax and correct error of your yml file again run

Docker compose config

If it shows the full code than your yml file works fine

Start up the Docker Compose service:

Run

docker compose up -d

Execute a compose up and use the detached flag to run the container in the background:

![Image22](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image22.png)

Verify that your app is up and running using the public IP address of your EC2 instance

![Image23](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image23.png)
Some important command of docker

**docker info**

**docker ps:**  shows only running containers

**Docker ps -a**

It shows all the containers

![Image25](https://github.com/gurpreet2828/Terraform-Docker/blob/f68bff62e5646f98e8d174bfec18c9d1eac09359/Images/Image25.png)
**Docker stop <container_name>:**

To stop the container

**Docker rm <container_name>:**

To delete the container

**Docker start <container_name>:**

 to start the container

**Docker search <image_name>**

Ex: docker search ubuntu: it search all the images regarding ubuntu present on ubuntu hub

![Image26](https://github.com/gurpreet2828/Terraform-Docker/blob/fe668ab95c2b25c233b90da636e62a15a3cf9b05/Images/Image26.png)

**Docker exec -it <container_name>**

To go inside the running docker

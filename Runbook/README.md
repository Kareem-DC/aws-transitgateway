# Runbook

## Task 1: Create First VPC

1. Choose your preferred Region: N. Virginia (us-east-1)

2. Services > VPC (under Networking and Content Delivery)

3. VPC > Create VPC:

    - Resource to create: VPC only
    - Name tag: first_vpc
    - IPv4 CIDR block: 10.0.0.0/24

4. Leave the rest default > Create VPC. Note the VPC ID

5. Select your VPC > Actions > Edit VPC settings

6. Check Enable DNS resolution and Enable DNS hostnames > Save

    - This matters because DNS hostnames are off by default on non-default VPCs. Without them, the instance won’t get a usable DNS hostname, which some connectivity tooling (including Session Manager) expects.

[Photo](Images/1-1.png)

![Photo](Images/1-2.png)

![Photo](Images/1-3.png)

![Photo](Images/1-4.png)

## Task 2: Create a Public Subnet in First VPC

1. Subnets > Create subnet

    - VPC ID: first_vpc
    - Subnet name: public_subnet_first_vpc
    - Availability Zone: No preference
    - IPv4 CIDR block: 10.0.0.0/25

2. Create subnet

3. Select public_subnet_first_vpc > Actions > Edit subnet settings

4. Check Enable auto-assign public IPv4 address > Save

![Photo](Images/2-1.png)

![Photo](Images/2-2.png)

![Photo](Images/2-3.png)

## Task 3: Create and Attach Internet Gateway (IGW)

1. Internet gateways > Create internet gateway

    - Name tag: igw_1

2. Create internet gateway

3. Select igw_1 > Actions > Attach to VPC

4. Choose first_vpc > Attach internet gateway

![Photo](Images/3-1.png)

![Photo](Images/3-2.png)

![Photo](Images/3-3.png)

## Task 4: Create a Public Route Table and Associate the Subnet

1. Route tables > Create route table

    - Name: PublicRT
    - VPC: first_vpc

2. Create route table

3. Open the Subnet associations tab > Edit subnet associations

4. Select public_subnet_first_vpc > Save associations

![Photo](Images/4-1.png)

![Photo](Images/4-2.png)

![Photo](Images/4-3.png)

![Photo](Images/4-4.png)

## Task 5: Add the Public Route

1. Select PublicRT > Routes tab > Edit routes > Add route

    - Destination: 0.0.0.0/0
    - Target: Internet Gateway > igw_1

2. Save changes

## Task 6: Create Security Group

1. EC2 > Security Groups > Create security group

2. Enter the basic details

    - Security group name: sg_01
    - Description: For first EC2 public instance
    - VPC: first_vpc

3. Add inbound rules

    - Type: SSH; Source: Anywhere IPv4 (0.0.0.0/0)
    - Type: HTTP; Source: Anywhere IPv4 (0.0.0.0/0)

4. Create security group

![Photo](Images/6-1.png)

![Photo](Images/6-2.png)

![Photo](Images/6-3.png)

## Task 7: Launch EC2 in First VPC (Public)

1. EC2 > Instances > Launch instances

2. Name: first_vpc_ec2

3. AMI: Amazon Linux 2023 kernel-6.8

    - Instance type: t2.micro

4. Configure the key pair

    - Create a new key pair, or select an existing one.
    - For a new key pair, choose a name such as in_the_air.pem.

5. Under Network settings, choose Edit

    - VPC: first_vpc
    - Subnet: public_subnet_first_vpc
    - Auto-assign public IP: Enable
    - Security group: Choose existing > sg_01

6. Under Advanced details, scroll to User data and paste:

    ```bash
    #!/bin/bash
    sudo dnf update -y
    sudo dnf install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "<html><h1>Welcome to Whizlabs Public Server</h1></html>" > /var/www/html/index.html
    ```

7. Launch the instance and wait until its status is Running

![Photo](Images/7-1.png)

![Photo](Images/7-2.png)

![Photo](Images/7-3.png)

![Photo](Images/7-4.png)

![Photo](Images/7-5.png)

![Photo](Images/7-6.png)

## Task 8: Create the Second VPC

1. Your VPCs > Create VPC

    - Resource to create: VPC only
    - Name tag: second_vpc
    - IPv4 CIDR block: 20.0.0.0/24

2. Create VPC

3. Select second_vpc > Actions > Edit VPC settings

4. Check Enable DNS resolution and Enable DNS hostnames > Save

![Photo](Images/8-1.png)

![Photo](Images/8-2.png)

![Photo](Images/8-3.png)

![Photo](Images/8-4.png)

## Task 9: Create a Private Subnet in Second VPC

1. Subnets > Create subnet

    - VPC ID: second_vpc
    - Subnet name: private_subnet_second_vpc
    - Availability Zone: No preference
    - IPv4 CIDR block: 20.0.0.0/25

2. Create subnet

    - No custom route table or internet gateway is required. The subnet uses the second VPC's main route table and has no internet route.

![Photo](Images/9-1.png)

![Photo](Images/9-2.png)

## Task 10: Create Security Group

1. EC2 > Security Groups > Create security group

2. Enter the basic details

    - Security group name: sg_02
    - Description: For second EC2 private instance
    - VPC: second_vpc

3. Add an inbound rule

    - Type: SSH; Source: 10.0.0.0/24 (First VPC CIDR)

4. Create security group

![Photo](Images/10-1.png)

## Task 11: Launch EC2 in Second VPC (Private)

1. EC2 > Instances > Launch instances

2. Name: second_vpc_ec2

3. AMI: Amazon Linux 2023 kernel-6.8

    - Instance type: t2.micro

4. Select the key pair used for the first instance

5. Under Network settings, choose Edit

    - VPC: second_vpc
    - Subnet: private_subnet_second_vpc
    - Auto-assign public IP: Disable
    - Security group: Choose existing > sg_02

6. Leave the remaining settings at their defaults > Launch instance

![Photo](Images/11-1.png)

![Photo](Images/11-2.png)

![Photo](Images/11-3.png)

![Photo](Images/11-4.png)

## Task 12: Create Transit Gateway

1. VPC > Transit Gateways > Create transit gateway

    - Name tag: TGW1
    - Description: TGW for peering two VPCs

2. Leave all other options at their defaults

3. Create transit gateway

![Photo](Images/12-1.png)

![Photo](Images/12-2.png)

## Task 13: Create the Transit Gateway Attachments

1. Transit gateway attachments > Create transit gateway attachment

    - Name: tgw_attach_01
    - Transit gateway ID: TGW1
    - Attachment type: VPC
    - DNS support: Enable
    - IPv6 support: Disable
    - VPC ID: first_vpc
    - Subnet: public_subnet_first_vpc

2. Create transit gateway attachment

3. Create the second attachment

    - Name: tgw_attach_02
    - Transit gateway ID: TGW1
    - Attachment type: VPC
    - VPC ID: second_vpc
    - Subnet: private_subnet_second_vpc

4. Create transit gateway attachment

![Photo](Images/13-1.png)

![Photo](Images/13-2.png)

![Photo](Images/13-3.png)

## Task 14: Route in First VPC Route Table

1. Route tables > Filter by VPC: first_vpc > Select PublicRT

2. Routes tab > Edit routes > Add route

    - Destination: 20.0.0.0/24
    - Target: Transit Gateway > TGW1

3. Save changes and confirm the 20.0.0.0/24 route is Active

![Photo](Images/14-1.png)

![Photo](Images/14-2.png)

![Photo](Images/14-3.png)

## Task 15: Route in Second VPC Route Table

1. Route tables > Filter by VPC: second_vpc > Select that VPC's main route table

2. Routes tab > Edit routes > Add route

    - Destination: 10.0.0.0/24
    - Target: Transit Gateway > TGW1

3. Save changes and confirm the route is Active

![Photo](Images/15-1.png)

![Photo](Images/15-2.png)

![Photo](Images/15-3.png)

## Task 16: Test Connectivity Between VPCs

1. EC2 > Instances > Select first_vpc_ec2 > Connect > EC2 Instance Connect > Connect

2. Update the instance

    ```bash
    sudo su
    dnf update -y
    ```

3. Copy the private key onto the bastion

    ```bash
    nano your-key-pair-here.pem
    ```

    - Paste the full contents of your local .pem file, then press Ctrl+X, Y, and Enter to save.

4. Restrict the key permissions

    ```bash
    chmod 400 your-key-pair-here.pem
    ```

5. SSH to the private instance using the private IP shown in the second_vpc_ec2 instance details, for example 20.0.0.xx

    ```bash
    ssh -i your-key-pair-here.pem ec2-user@20.0.0.xx
    ```

6. Type yes at the host key prompt

7. Successful access displays a prompt similar to the following:

    ```text
    [ec2-user@ip-20-0-0-xx ~]$
    ```

![Photo](Images/16-1.png)

![Photo](Images/16-2.png)

![Photo](Images/16-3.png)

![Photo](Images/16-4.png)

![Photo](Images/16-5.png)

![Photo](Images/16-6.png)

![Photo](Images/16-7.png)

![Photo](Images/16-8.png)

## Task 17: Tear Down

1. Terminate both EC2 instances: EC2 > Instances > Select either instance > Instance state > Terminate instance

2. Delete both transit gateway attachments

3. Delete the transit gateway

4. Remove the TGW routes from both route tables

5. Delete the custom route table

6. Detach and delete the internet gateway

7. Delete both subnets

8. Delete both security groups

9. Delete both VPCs

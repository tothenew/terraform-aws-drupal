#### Note: All the variables have default values in Example Folder (except VPC and Security Group). In case, a user does not provide values in .tfvars, then the project will use default values to set up the Drupal infrastructure.

## ASG
- Horizontal Auto Scaling to scale EC2 instances up or down according to the requirement
- Varnish cache to reduce the response time and network bandwidth consumption on future similar requests
- All the required ASG variables have default values except subnet and security group 

### Telegraf
- Collection agent for collecting and sending metrics of EC2 instances to Cloudwatch 

### Fluentbit
- Log Processor and Forwarder to collect access and error logs of Apache and send it to Cloudwatch

## RDS
- RDS to manage and store drupal data, both static and dynamic
- RDS provides Multi-AZ automated failover in event of an outage to maintain the running state of your website 
- Read replica to maintain a copy of database in a different region for disaster recovery 
- All the required RDS variables have default values except subnet and security group

## EFS
- Fully managed EFS for drupal EC2 instances as shared storage for uploaded files
- All the required EFS variables have default values except vpc, subnet and security group

## ALB
- ALB with content-routing (host routing) and the ability to run drupal website on different domain, if needed
- All the required ALB variables have default values except vpc, subnet and security group

## Route53 
- Scalable DNS to resolve the domain name of the drupal websites 
- All the required Route53 variables have default values 

# Infrastructure

- All the variables have default values (except VPC and Security Group). 
- In case, a user does not provide values in .tfvars, then the project will use default values to set up the Drupal infrastructure.
- This repository is reusable. 
- A user can set up the whole infrastructure if he wants to create the whole setup. 
- Resources like ALB and Route53 can also be passed from outside, if the user requires.

## How to use it

### Prerequisite:
- Create a drupal folder with all the necessary files in your local system (example folder is mentioned with all the required files)
- Initialize the working directory 
- Give all the values accordingly in .tfvars 
- Set-up the terraform infrastructure

- Example folder contains the following: VPC, Security Groups with all the minimal required rules
  - Edit cidr_blocks and give your IP

Security Group for ASG:

```
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "all"
      description = "Open internet"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  ingress_with_cidr_blocks = [

    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "205.254.162.172/32"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "205.254.162.172/32"
    },
    {
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      description = "NFS"
      cidr_blocks = "205.254.162.172/32"
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "ALB Port Open in ASG"
      cidr_blocks = "10.99.0.0/18"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "205.254.162.172/32"
    }
  ]
```
Security Group for ASG:

```
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "all"
      description = "Open internet"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "All TCP"
      cidr_blocks = "205.254.162.172/32"
    }
  ]

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      description              = "Added ASG SG"
      source_security_group_id = module.security_group_asg.security_group_id
    }
  ]
```

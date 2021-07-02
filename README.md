# terraform-drupal

Repository that hosts terraform code to launch drupal/magento setup in AWS cloud

# Setting up local environment

## Prerequisites

- GNU Make
- Docker and Docker compose
- Pre-Commit
- Checkov
 

#### How to setup the local environment.

- Copy the [.env-template](./.env-template) content from terraform-drupal directory and make a file on your local system in the same directory with .env name.
- Edit the Access Key ID, Secret Access Key, Sessiontoken (optional, required in case you are using temporary credentials. ) and Region according to the requirement.
- To check whether the changes are correct, run the command "make plan".

### [How to Contribute](./CONTRIBUTING.md)


# Features

- ASG: Horizontal Auto Scaling, Scaled Varnish Cache
- RDS: Fully managed database to store data for drupal site
- EFS: Scalable Network file system for instances to access shared Drupal data 
- ALB: Route traffic to applications based on Host-based routing 
- Route53: DNS to resolve the domain name of drupal website

#### Note: All the variables have default values (except VPC and Security Group). In case, a user does not provide values in tfvars, then the project will use default values to set up the Drupal infrastructure.

## ASG
- Horizontal Auto Scaling to scale EC2 instances up or down according to the requirement
- Varnish cache to reduce the response time and network bandwidth consumption on future similar requests
- All the required ASG variables have default values except subnet and security group 

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
Scalable DNS to resolve the domain name of the drupal websites 
All the required Route53 variables have default values 

# Infrastructure

All the variables have default values (except VPC and Security Group). 
In case, a user does not provide values in tfvars, then the project will use default values to set up the Drupal infrastructure.
This repository is reusable. 
A user can set up the whole infrastructure if he wants to create the whole setup. 
Resources like ALB and Route53 can also be passed from outside, if the user requires.

## How to use it

If the user wants to pass ALB from outside instead of creating it:
Pass the target group arn value for target_group_drupal attribute
Also, pass the DNS name for route53_lb_dns_name attribute, if the user wants to create a route53 record instead of passing it from outside. 
If the user wants to pass Route53 from outside instead of creating it:
Pass true to createUpdateDNSRecord and it also gives the value of the hosted zone to create a record inside. 

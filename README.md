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

- ASG: Horizontal Auto Scaling
- Varnish: Scaled Varnish Cache
- Telegraf: Collect and send metrics
- Fluentbit: Collect and send logs 
- RDS: Fully managed database to store data for drupal site
- EFS: Scalable Network file system for instances to access shared Drupal data 
- ALB: Route traffic to applications based on Host-based routing 
- Route53: DNS to resolve the domain name of drupal website


## How to use it

- If the user wants to pass ALB from outside instead of creating it:
  - Pass the target group arn value for target_group_drupal variable
  - Also, pass the DNS name for route53_lb_dns_name variable, if the user wants to create a route53 record instead of passing it from outside. 
- If the user wants to pass Route53 from outside instead of creating it:
  - Pass true to createUpdateDNSRecord and it also gives the value of the hosted zone to create a record inside. 
- If the user wants to install telegraf:
  - Pass true value for installTelegraf variable
- If the user wants to install fluentbit:
  - Pass true value for installFluentbit variable
- If the user wants to create RDS Read Replica:
  - Pass true value for createReadReplica variable

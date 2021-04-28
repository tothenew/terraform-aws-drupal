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

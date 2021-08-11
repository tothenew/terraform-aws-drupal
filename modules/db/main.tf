locals {
  name = "complete-mysql"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

resource "random_password" "rds_master_password" {
  length           = 8
  number           = false
  special          = true
  override_special = "_%@"
}

module "secrets_manager" {
  source = "lgallard/secrets-manager/aws"

  secrets = [
   {
      name        = "secret-kv-1"
      description = "This is a key/value secret for RDS cluster"
      secret_key_value = {
        username = var.username
        password = random_password.rds_master_password.result
      }
      recovery_window_in_days = 0
    }
 ]
}

data "aws_secretsmanager_secret" "rds_master_arn" {
  arn = module.secrets_manager.secret_arns[0]
}

data "aws_secretsmanager_secret_version" "rds_master_creds" {
  secret_id = data.aws_secretsmanager_secret.rds_master_arn.id
}

output "rds_password" {
  value = jsondecode(data.aws_secretsmanager_secret_version.rds_master_creds.secret_string)["password"]
}

module "terraform-aws-rds-source" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-rds.git?ref=v3.0.0"

  identifier = var.identifier_source

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class_source

  # Define the max_allocated_storage argument higher than the allocated_storage argument
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  name     = var.name_source
  username = var.username
  password = jsondecode(data.aws_secretsmanager_secret_version.rds_master_creds.secret_string)["password"]

  port     = var.port

  parameter_group_name = var.parameter_group_name

  # Disable creation of parameter group - provide a parameter group or default to AWS default
  # Create_option_group = false if parameter_group_name must already exist in AWS or using a default option group provided by AWS
  create_db_parameter_group = var.create_db_parameter_group

  # Disable creation of option group - provide an option group or default AWS default
  create_db_option_group = var.create_db_option_group

  maintenance_window = var.maintenance_window_source
  backup_window      = var.backup_window_source

  # Backups are required in order to create a replica
  backup_retention_period = var.backup_retention_period
  # If false is specified, a DB snapshot is created before the DB instance is deleted
  skip_final_snapshot = var.skip_final_snapshot_source

  subnet_ids             = var.subnet_rds
  vpc_security_group_ids = [var.sec_group_rds]
}

output "rds_endpoint" {
  value = module.terraform-aws-rds-source.db_instance_endpoint
}

module "terraform-aws-rds-read" {

  count = var.createRDSReadReplica == true ? 1 : 0

  source = "git@github.com:terraform-aws-modules/terraform-aws-rds.git?ref=v3.0.0"

  identifier = var.identifier_read

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class_read

  # Define the max_allocated_storage argument higher than the allocated_storage argument
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  # Username and password should not be set for replicas
  name     = var.name_read
  username = null
  password = null
  port     = var.port

  parameter_group_name = var.parameter_group_name

  # Disable creation of parameter group - provide a parameter group or default to AWS default
  # Create_option_group = false if parameter_group_name must already exist in AWS or using a default option group provided by AWS
  create_db_parameter_group = var.create_db_parameter_group

  # Disable creation of option group - provide an option group or default AWS default
  create_db_option_group = var.create_db_option_group

  maintenance_window = var.maintenance_window_read
  backup_window      = var.backup_window_read

  #for read replica
  replicate_source_db = module.terraform-aws-rds-source.db_instance_id

  backup_retention_period = var.backup_retention_period
  # If false is specified, a DB snapshot is created before the DB instance is deleted
  skip_final_snapshot = var.skip_final_snapshot_read

  # Disable creation of subnet group - provide a subnet group
  create_db_subnet_group = false
}

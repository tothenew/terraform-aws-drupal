locals {
  name = "complete-mysql"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

module "terraform-aws-rds-source" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-rds.git?ref=v3.0.0"

  identifier = "mysql-source"

  engine         = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"

  allocated_storage     = 50
  max_allocated_storage = 100

  name     = "mydb_source"
  username = "drupaladmin"
  password = "redhat22"
  port     = 3306

  parameter_group_name      = "default.mysql5.7"
  create_db_parameter_group = false
  create_db_option_group    = false

  maintenance_window = "Sun:05:00-Sun:06:00"
  backup_window      = "09:46-10:16"

  backup_retention_period = 10
  skip_final_snapshot     = true

  subnet_ids             = var.subnet_rds
  vpc_security_group_ids = [var.sec_group_rds]
}

output "rds_endpoint" {
  value = module.terraform-aws-rds-source.db_instance_endpoint
}

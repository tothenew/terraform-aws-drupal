locals {
  name = "complete-mysql"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

module "db_default" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-rds.git?ref=v3.0.0"

  identifier = "${local.name}-default"

  create_db_option_group    = false
  create_db_parameter_group = false

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine               = "mysql"
  engine_version       = "8.0.20"
  family               = "mysql8.0" # DB parameter group
  major_engine_version = "8.0"      # DB option group
  instance_class       = "db.t3.large"

  allocated_storage = 20

  name                   = "completeMysql"
  username               = "complete_mysql"
  create_random_password = true
  random_password_length = 12
  port                   = 3306

  subnet_ids             = ["10.1.1.0/24", "10.1.0.0/24"]
  vpc_security_group_ids = ["sg-02d4b540de296feb2"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 0

  tags = local.tags
}

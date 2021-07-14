locals {
  name = "demo-vpc"
}

# VPC

module "vpc" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=v3.0.0"

  name = local.name
  cidr = "10.99.0.0/18"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets  = ["10.99.0.0/24", "10.99.1.0/24", "10.99.2.0/24"]
  private_subnets = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
}


# Security Group for ASG

module "security_group_asg" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-security-group.git?ref=v4.0.0"

  name   = "security-group_asg"
  vpc_id = module.vpc.vpc_id
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
}


# Security Group for RDS

module "security_group_rds" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-security-group.git?ref=v4.0.0"

  name   = "security-group_rds"
  vpc_id = module.vpc.vpc_id
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

  number_of_computed_ingress_with_source_security_group_id = 1
}


# Sample ALB(which is passed from outside)

module "test_alb" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-alb.git?ref=v6.0.0"

  name = "test-alb"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.security_group_asg.security_group_id]

  target_groups = [
    {
      name             = "test-target-group"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 110
        path                = "/drupal"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 100
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "forward"
    }
  ]

  tags = {
    Project = "terraform_drupal"
    Name    = "terraform_asg_cluster"
    BU      = "demo-testing"
    Owner   = "pratishtha.verma@tothenew.com"
    Purpose = "gtihub project"
  }
}


# Main Drupal Module

module "drupal" {

  # In the source, give terraform-aws-drupal git link (git@github.com:IntelliGrape/terraform-aws-drupal.git)
  source = "../terraform-aws-drupal/"

  #Route53

  #URL of Route53 record is passed
  drupal_record_url = var.drupal_record_url

  #{only if createDNSRecord is true}
  route53_hosted_zone   = var.route53_hosted_zone
  createUpdateDNSRecord = false

  #If Route53 is created inside with ALB of outside
  #route53_lb_dns_name   = module.test_alb.lb_dns_name


  #ASG Variables

  #If ALB is passed from outside
  #target_group_drupal   = module.test_alb.target_group_arns

  installTelegraf  = var.installTelegraf
  installFluentbit = var.installFluentbit

  asg_subnet_drupal    = module.vpc.public_subnets
  asg_sec_group_drupal = module.security_group_asg.security_group_id

  asg_name                      = var.asg_name
  asg_min_size                  = var.asg_min_size
  asg_max_size                  = var.asg_max_size
  asg_desired_capacity          = var.asg_desired_capacity
  asg_wait_for_capacity_timeout = var.asg_wait_for_capacity_timeout
  asg_health_check_type         = var.asg_health_check_type
  asg_lt_name                   = var.asg_lt_name
  asg_description               = var.asg_description
  asg_use_lt                    = var.asg_use_lt
  asg_create_lt                 = var.asg_create_lt
  asg_image_id                  = var.asg_image_id
  asg_instance_type             = var.asg_instance_type
  asg_key_name                  = var.asg_key_name
  asg_health_check_grace_period = var.asg_health_check_grace_period


  #DB Variables

  createReadReplica = var.createReadReplica

  rds_sec_group_drupal = module.security_group_rds.security_group_id
  rds_subnet_drupal    = module.vpc.public_subnets

  rds_identifier_source          = var.rds_identifier_source
  rds_engine                     = var.rds_engine
  rds_engine_version             = var.rds_engine_version
  rds_instance_class_source      = var.rds_instance_class_source
  rds_allocated_storage          = var.rds_allocated_storage
  rds_max_allocated_storage      = var.rds_max_allocated_storage
  rds_name_source                = var.rds_name_source
  rds_username                   = var.rds_username
  rds_password                   = var.rds_password
  rds_port                       = var.rds_port
  rds_parameter_group_name       = var.rds_parameter_group_name
  rds_create_db_parameter_group  = var.rds_create_db_parameter_group
  rds_create_db_option_group     = var.rds_create_db_option_group
  rds_maintenance_window_source  = var.rds_maintenance_window_source
  rds_backup_window_source       = var.rds_backup_window_source
  rds_backup_retention_period    = var.rds_backup_retention_period
  rds_skip_final_snapshot_source = var.rds_skip_final_snapshot_source
  rds_identifier_read            = var.rds_identifier_read
  rds_name_read                  = var.rds_name_read
  rds_instance_class_read        = var.rds_instance_class_read
  rds_maintenance_window_read    = var.rds_maintenance_window_read
  rds_backup_window_read         = var.rds_backup_window_read
  rds_skip_final_snapshot_read   = var.rds_skip_final_snapshot_read
  rds_create_db_subnet_group     = var.rds_create_db_subnet_group


  #EFS Variables

  efs_vpc_drupal       = module.vpc.vpc_id
  efs_subnet_drupal    = module.vpc.public_subnets
  efs_sec_group_drupal = module.security_group_asg.security_group_id

  efs_namespace = var.efs_namespace
  efs_stage     = var.efs_stage
  efs_name      = var.efs_name
  efs_region    = var.efs_region


  #ALB Variables

  alb_vpc_drupal       = module.vpc.vpc_id
  alb_sec_group_drupal = module.security_group_asg.security_group_id
  alb_subnet_drupal    = module.vpc.public_subnets

  alb_name                                                = var.alb_name
  alb_load_balancer_type                                  = var.alb_load_balancer_type
  alb_target_groups_name                                  = var.alb_target_groups_name
  alb_target_groups_backend_protocol                      = var.alb_target_groups_backend_protocol
  alb_target_groups_backend_port                          = var.alb_target_groups_backend_port
  alb_target_groups_target_type                           = var.alb_target_groups_target_type
  alb_target_groups_health_check_enabled                  = var.alb_target_groups_health_check_enabled
  alb_target_groups_health_check_interval                 = var.alb_target_groups_health_check_interval
  alb_target_groups_health_check_path                     = var.alb_target_groups_health_check_path
  alb_target_groups_health_check_port                     = var.alb_target_groups_health_check_port
  alb_target_groups_health_check_healthy_threshold        = var.alb_target_groups_health_check_healthy_threshold
  alb_target_groups_health_check_unhealthy_threshold      = var.alb_target_groups_health_check_unhealthy_threshold
  alb_target_groups_health_check_timeout                  = var.alb_target_groups_health_check_timeout
  alb_target_groups_health_check_protocol                 = var.alb_target_groups_health_check_protocol
  alb_target_groups_health_check_matcher                  = var.alb_target_groups_health_check_matcher
  alb_target_groups_http_tcp_listeners_port               = var.alb_target_groups_http_tcp_listeners_port
  alb_target_groups_http_tcp_listeners_protocol           = var.alb_target_groups_http_tcp_listeners_protocol
  alb_target_groups_http_tcp_listeners_target_group_index = var.alb_target_groups_http_tcp_listeners_target_group_index
  alb_target_groups_http_tcp_listeners_action_type        = var.alb_target_groups_http_tcp_listeners_action_type
}

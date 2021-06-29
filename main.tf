module "asg" {
  source = "./modules/asg/"

  subnet_asg    = var.asg_subnet_drupal
  sec_group_asg = var.asg_sec_group_drupal

  rds_point  = module.db.rds_endpoint
  depends_on = [module.db.rds_endpoint]

  target_gp = var.target_group_drupal != null ? var.target_group_drupal : module.alb[0].target_group_arns

  dns_name = module.efs.dns_name_efs

  name                      = var.asg_name
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  wait_for_capacity_timeout = var.asg_wait_for_capacity_timeout
  health_check_type         = var.asg_health_check_type
  lt_name                   = var.asg_lt_name
  description               = var.asg_description
  use_lt                    = var.asg_use_lt
  create_lt                 = var.asg_create_lt
  image_id                  = var.asg_image_id
  instance_type             = var.asg_instance_type
  key_name                  = var.asg_key_name
  health_check_grace_period = var.asg_health_check_grace_period
}

module "db" {
  source        = "./modules/db/"
  sec_group_rds = var.rds_sec_group_drupal
  subnet_rds    = var.rds_subnet_drupal

  identifier_source          = var.rds_identifier_source
  engine                     = var.rds_engine
  engine_version             = var.rds_engine_version
  instance_class_source      = var.rds_instance_class_source
  allocated_storage          = var.rds_allocated_storage
  max_allocated_storage      = var.rds_max_allocated_storage
  name_source                = var.rds_name_source
  username                   = var.rds_username
  password                   = var.rds_password
  port                       = var.rds_port
  parameter_group_name       = var.rds_parameter_group_name
  create_db_parameter_group  = var.rds_create_db_parameter_group
  create_db_option_group     = var.rds_create_db_option_group
  maintenance_window_source  = var.rds_maintenance_window_source
  backup_window_source       = var.rds_backup_window_source
  backup_retention_period    = var.rds_backup_retention_period
  skip_final_snapshot_source = var.rds_skip_final_snapshot_source
  create_db_subnet_group     = var.rds_create_db_subnet_group
}

module "efs" {
  source        = "./modules/efs/"
  subnet_efs    = var.efs_subnet_drupal
  sec_group_efs = var.efs_sec_group_drupal
  vpc_efs       = var.efs_vpc_drupal

  namespace = var.efs_namespace
  stage     = var.efs_stage
  name      = var.efs_name
  region    = var.efs_region
}

module "alb" {
  count = var.target_group_drupal == null ? 1 : 0

  source = "git@github.com:terraform-aws-modules/terraform-aws-alb.git?ref=v6.0.0"

  name = var.alb_name

  load_balancer_type = var.alb_load_balancer_type

  vpc_id          = var.alb_vpc_drupal
  subnets         = var.alb_subnet_drupal
  security_groups = [var.alb_sec_group_drupal]

  target_groups = [
    {
      name             = var.alb_target_groups_name
      backend_protocol = var.alb_target_groups_backend_protocol
      backend_port     = var.alb_target_groups_backend_port
      target_type      = var.alb_target_groups_target_type
      health_check = {
        enabled             = var.alb_target_groups_health_check_enabled
        interval            = var.alb_target_groups_health_check_interval
        path                = var.alb_target_groups_health_check_path
        port                = var.alb_target_groups_health_check_port
        healthy_threshold   = var.alb_target_groups_health_check_healthy_threshold
        unhealthy_threshold = var.alb_target_groups_health_check_unhealthy_threshold
        timeout             = var.alb_target_groups_health_check_timeout
        protocol            = var.alb_target_groups_health_check_protocol
        matcher             = var.alb_target_groups_health_check_matcher
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = var.alb_target_groups_http_tcp_listeners_port
      protocol           = var.alb_target_groups_http_tcp_listeners_protocol
      target_group_index = var.alb_target_groups_http_tcp_listeners_target_group_index
      action_type        = var.alb_target_groups_http_tcp_listeners_action_type
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

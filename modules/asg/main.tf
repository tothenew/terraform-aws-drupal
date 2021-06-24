locals {
  name = "demo-asg"
}

module "aws_autoscaling_group" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-autoscaling.git?ref=v4.1.0"

  # Autoscaling group

  name                      = var.name
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  health_check_type         = var.health_check_type
  vpc_zone_identifier       = var.subnet_asg
  security_groups           = [var.sec_group_asg]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
  }

  #instance_refresh_strategy
  #instance_refresh_min_healthy_percentage

  # Launch template
  lt_name     = var.lt_name
  description = var.description
  use_lt      = var.use_lt
  create_lt   = var.create_lt

  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  #user_data_base64 = base64encode(local.user_data)

  user_data_base64 = base64encode(templatefile("${path.module}/userdata.sh", {
    rds_endpt = var.rds_point, efs_dns_name = var.dns_name
  }))

  target_group_arns = var.target_gp

  health_check_grace_period = var.health_check_grace_period

  tags = [
    {
      key                 = "Project"
      value               = "terraform_drupal"
      propagate_at_launch = "true"
    },
    {
      key                 = "Name"
      value               = "terraform_asg_cluster"
      propagate_at_launch = "true"
    },
    {
      key                 = "BU"
      value               = "demo-testing"
      propagate_at_launch = "true"
    },
    {
      key                 = "Owner"
      value               = "pratishtha.verma@tothenew.com"
      propagate_at_launch = "true"
    },
    {
      key                 = "Purpose"
      value               = "gtihub project"
      propagate_at_launch = "true"
    }
  ]
}

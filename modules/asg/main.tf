locals {
  name = "demo-asg"
}

module "aws_autoscaling_group" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-autoscaling.git?ref=v4.1.0"

  # Autoscaling group
  name = "demo-testing"

  min_size                  = 1
  max_size                  = 5
  desired_capacity          = 2
  wait_for_capacity_timeout = "5m"
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.subnet_asg
  security_groups           = [var.sec_group_asg]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
  }

  # Launch template
  lt_name     = "foobar"
  description = "Complete launch template example"
  use_lt      = true
  create_lt   = true

  image_id      = "ami-090717c950a5c34d3"
  instance_type = "t3a.medium"
  key_name      = "pratishtha-testing"
  #user_data_base64 = base64encode(local.user_data)
  user_data_base64 = base64encode(templatefile("${path.module}/userdata.sh", {
    rds_endpt = var.rds_point, efs_dns_name = var.dns_name
  }))

  target_group_arns = var.target_gp

  health_check_grace_period = 300

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

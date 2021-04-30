locals {
  name      = "example-asg"
  user_data = <<-EOT
  #!/bin/bash
  apt-get update
  apt-get install -y nginx
  systemctl start nginx
  systemctl enable nginx
  echo "Hello World from user data" > /var/www/html/index.html
  EOT
}

module "vpc" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=v3.0.0"

  name = local.name
  cidr = "10.99.0.0/18"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.99.0.0/24", "10.99.1.0/24", "10.99.2.0/24"]
  private_subnets = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "security_group" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-security-group.git?ref=v4.0.0"

  name   = "security-group"
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
      cidr_blocks = "110.235.219.9/32"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "110.235.219.9/32"
    }
  ]
}

module "aws_autoscaling_group" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-autoscaling.git?ref=v4.1.0"

  # Autoscaling group
  name = "demo-test"

  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = "5m"
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.public_subnets
  security_groups           = [module.security_group.security_group_id]


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

  image_id         = "ami-013f17f36f8b1fefb"
  instance_type    = "t2.micro"
  key_name         = "pratishtha-demo-test"
  user_data_base64 = base64encode(local.user_data)

  health_check_grace_period = 300

  tags = [
    {
      key   = "Project"
      value = "terraform_drupal"
    },
    {
      key   = "Name"
      value = "terraform_asg_cluster"
    },
    {
      key   = "BU"
      value = "demo-testing"
    },
    {
      key   = "Owner"
      value = "pratishtha.verma@tothenew.com"
    },
    {
      key   = "Purpose"
      value = "gtihub project"
    }
  ]
}

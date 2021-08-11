locals {
  name = "demo-asg"
}

resource "null_resource" "shell" {
  provisioner "local-exec" {
      # Bootstrap script called with private_ip of each node in the cluster
      command = <<EOT
        aws s3 cp s3://demo-testing-drupal/demo.sql /home/ubuntu/demo.sql
        x=$(echo ${var.rds_point} | cut -d':' -f1)
        mysql --user=${var.db_username} --password=${var.db_password} -h $x -e "CREATE DATABASE drupal1; CREATE USER 'drupal1'@'%' IDENTIFIED BY 'drupalpass'; GRANT ALL PRIVILEGES ON drupal1.* TO 'drupal1'@'%'; FLUSH PRIVILEGES;"
        sed -i '/SET @@SESSION.SQL_LOG_BIN= 0;/s/^/-- /g' /home/ubuntu/demo.sql
        sed -i '/SET @@GLOBAL.GTID_PURGED/s/^/-- /g' /home/ubuntu/demo.sql
        sed -i '/SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;/s/^/-- /g' /home/ubuntu/demo.sql
        sed -i /home/ubuntu/demo.sql -e 's/utf8mb4_0900_ai_ci/utf8mb4_unicode_ci/g'
        mysql --user=${var.db_username} --password=${var.db_password} -h $x drupal1 < /home/ubuntu/demo.sql
      EOT
    }
}

data "template_file" "userdata" {
  template = file("${path.module}/userdata.sh")
  vars = {
    rds_endpt = var.rds_point
  }
}
#efs_dns_name = var.dns_name

data "template_file" "telegraf" {
  template = file("${path.module}/telegraf.sh")
  vars = {
    role_arn = var.rolearn, installTelegrafCWMetrics = var.installTelegrafCW
  }
}

data "template_file" "fluentbit" {
  template = file("${path.module}/fluentbit.sh")
  vars = {
    installFluentbitCWMetrics = var.installFluentbitCW
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "userdata.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.userdata.rendered
  }

  part {
    filename     = "telegraf.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.telegraf.rendered
  }

  part {
    filename     = "fluentbit.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.fluentbit.rendered
  }
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
  iam_instance_profile_arn  = aws_iam_instance_profile.ssm.arn

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

  user_data_base64 = data.template_cloudinit_config.config.rendered

  #base64encode(templatefile("${path.module}/userdata.sh", {
  #rds_endpt = var.rds_point, efs_dns_name = var.dns_name, role_arn = var.rolearn, installTelegrafCWMetrics = var.installTelegrafCW
  #}))

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


# Role and Policies

# Role and Policy - telegraf
resource "aws_iam_instance_profile" "ssm_cloudwatch" {
  name = "test_role_1"
  role = aws_iam_role.test_role_cloudwatch.name
}

resource "aws_iam_role_policy" "test_policy_cloudwatch" {
  name = "test_policy_1"
  role = aws_iam_role.test_role_cloudwatch.id

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "VisualEditor0",
        Effect : "Allow",
        Action : "cloudwatch:PutMetricData",
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role" "test_role_cloudwatch" {
  name = "test_role_1"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          AWS : aws_iam_role.ssm_role.arn,
          Service : "ec2.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}

output "rolearncw" {
  value = aws_iam_role.test_role_cloudwatch.arn
}

# Role and Policy - fluentbit
resource "aws_iam_role_policy" "test_policy_fluentbit" {
  name = "test_policy_fluentbit"
  role = aws_iam_role.ssm_role.id

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "VisualEditor0",
        Effect : "Allow",
        Action : [
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutRetentionPolicy",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ],
        Resource : "*"
      }
    ]
  })
}

# Role and Policy - S3 Full Access
resource "aws_iam_role_policy" "test_policy_s3_access" {
  name = "test_policy_s3_access"
  role = aws_iam_role.ssm_role.id

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
 })
}

# Role and Policy - Main
resource "aws_iam_instance_profile" "ssm" {
  name = "test_role_2"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy" "ssm_policy" {
  name = "test_policy_2"
  role = aws_iam_role.ssm_role.id

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "VisualEditor0",
        Effect : "Allow",
        Action : "sts:AssumeRole",
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role" "ssm_role" {
  name = "test_role_2"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Service : "ec2.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}

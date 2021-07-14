#Route53 Variables

variable "drupal_record_url" {
  description = "The URL of Route53 Record"
  type        = string
  default     = "demo.terraform-drupal.com"
}

variable "route53_hosted_zone" {
  description = "Zone ID of Route53 zone. If the createUpdateDNSRecord is true then pass zone id"
  type        = string
  default     = null
  #"Z02615571SCDW5JDEBEP4"
}

variable "createUpdateDNSRecord" {
  description = "If the value is true, then create the Route53 record"
  type        = bool
  default     = false
}

variable "route53_lb_dns_name" {
  description = "The DNS name of Load Balancer"
  default     = null
}


#ASG Variables

variable "target_group_drupal" {
  description = "The ARN of Target Group"
  default     = null
}

variable "installTelegraf" {
  description = "Whether the user wants to install Telegraf or not"
  type        = bool
  default     = true
}

variable "installFluentbit" {
  description = "Whether the user wants to install Fluentbit or not"
  type        = bool
  default     = true
}

variable "asg_subnet_drupal" {
  description = "A list of security group IDs to associate"
  type        = list(string)
  default     = null
}

variable "asg_sec_group_drupal" {
  description = "A list of security group IDs to associate"
  type        = string
  default     = null
}

variable "asg_name" {
  description = "Name used across the resources created"
  type        = string
  default     = "drupal-demo-testing"
}

variable "asg_min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
  type        = number
  default     = 2
}

variable "asg_wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  type        = string
  default     = "8m"
}

variable "asg_health_check_type" {
  description = "`EC2` or `ELB`. Controls how health checking is done"
  type        = string
  default     = "EC2"
}

variable "asg_lt_name" {
  description = "Name of launch template to be created"
  type        = string
  default     = "foobar"
}

variable "asg_description" {
  description = "(LT) Description of the launch template"
  type        = string
  default     = "Complete Drupal Launch Template Example"
}

variable "asg_use_lt" {
  description = "Determines whether to use a launch template in the autoscaling group or not"
  type        = bool
  default     = true
}

variable "asg_create_lt" {
  description = "Determines whether to create launch template or not"
  type        = bool
  default     = true
}

variable "asg_image_id" {
  description = "The AMI from which to launch the instance"
  type        = string
  default     = "ami-090717c950a5c34d3"
}

variable "asg_instance_type" {
  description = "The type of the instance to launch"
  type        = string
  default     = "t3a.medium"
}

variable "asg_key_name" {
  description = "The key name that should be used for the instance"
  type        = string
  default     = "pratishtha-testing"
}

variable "asg_health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 300
}


#DB Variables

variable "createReadReplica" {
  description = "Whether the user wants to create Read Replica or not"
  type        = bool
  default     = false
}

variable "rds_sec_group_drupal" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = null
}

variable "rds_subnet_drupal" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = null
}

variable "rds_identifier_source" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
  default     = "drupal-mysql-source"
}

variable "rds_engine" {
  description = "The database engine to use"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "5.7"
}

variable "rds_instance_class_source" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
  default     = 50
}

variable "rds_max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 100
}

variable "rds_name_source" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = "mydb_source"
}

variable "rds_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "drupaladmin"
}

variable "rds_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  default     = "redhat22"
}

variable "rds_port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = 3306
}

variable "rds_parameter_group_name" {
  description = "Name of the DB parameter group to associate or create"
  type        = string
  default     = "default.mysql5.7"
}

variable "rds_create_db_parameter_group" {
  description = "Whether to create a database parameter group"
  type        = bool
  default     = false
}

variable "rds_create_db_option_group" {
  description = "Create a database option group"
  type        = bool
  default     = false
}

variable "rds_maintenance_window_source" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "Sun:05:00-Sun:06:00"
}

variable "rds_backup_window_source" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = "09:46-10:16"
}

variable "rds_backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 10
}

variable "rds_skip_final_snapshot_source" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = true
}

variable "rds_identifier_read" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
  default     = "mysql-read"
}

variable "rds_name_read" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = "mydb_read"
}

variable "rds_instance_class_read" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_maintenance_window_read" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "Sun:05:00-Sun:06:00"
}

variable "rds_backup_window_read" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = "09:46-10:16"
}

variable "rds_skip_final_snapshot_read" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = true
}

variable "rds_create_db_subnet_group" {
  description = "Whether to create a database subnet group"
  type        = bool
  default     = false
}


#EFS Variables
variable "efs_vpc_drupal" {
  description = "VPC ID"
  type        = string
  default     = null
}

variable "efs_subnet_drupal" {
  description = "Subnet IDs"
  type        = list(string)
  default     = null
}

variable "efs_sec_group_drupal" {
  description = "A list of Security Group IDs to associate with EFS"
  type        = string
  default     = null
}

variable "efs_namespace" {
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
  type        = string
  default     = "drupal-demo"
}

variable "efs_stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
  type        = string
  default     = "test"
}

variable "efs_name" {
  description = "Solution name, e.g. 'app' or 'jenkins'"
  type        = string
  default     = "app"
}

variable "efs_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}


#ALB Variables

variable "alb_vpc_drupal" {
  description = "VPC ID"
  type        = string
  default     = null
}

variable "alb_subnet_drupal" {
  description = "Subnet IDs"
  type        = list(string)
  default     = null
}

variable "alb_sec_group_drupal" {
  description = "The security groups to attach to the load balancer."
  type        = string
  default     = null
}

variable "alb_name" {
  description = "The resource name and Name tag of the load balancer."
  type        = string
  default     = "drupal-demo-alb"
}

variable "alb_load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application or network."
  type        = string
  default     = "application"
}

variable "alb_target_groups_name" {
  description = "The name tag for the target group of the load balancer."
  type        = string
  default     = "drupal-demo-target-group"
}

variable "alb_target_groups_backend_protocol" {
  description = "The protocol specified for the Target Group"
  type        = string
  default     = "HTTP"
}

variable "alb_target_groups_backend_port" {
  description = "The port specified for the Target Group"
  type        = number
  default     = 80
}

variable "alb_target_groups_target_type" {
  description = "The target type specified for the Target Group"
  type        = string
  default     = "instance"
}

variable "alb_target_groups_health_check_enabled" {
  description = "The health check specified for the Target Group"
  type        = bool
  default     = true
}

variable "alb_target_groups_health_check_interval" {
  description = "The target health check interval specified for the Target Group"
  type        = number
  default     = 110
}

variable "alb_target_groups_health_check_path" {
  description = "The target health check path specified for the Target Group"
  type        = string
  default     = "/drupal"
}

variable "alb_target_groups_health_check_port" {
  description = "The target health check path specified for the Target Group"
  type        = string
  default     = "traffic-port"
}

variable "alb_target_groups_health_check_healthy_threshold" {
  description = "The target health check healthy threshold specified for the Target Group"
  type        = number
  default     = 3
}

variable "alb_target_groups_health_check_unhealthy_threshold" {
  description = "The target health check unhealthy threshold specified for the Target Group"
  type        = number
  default     = 3
}

variable "alb_target_groups_health_check_timeout" {
  description = "The target health check timeout specified for the Target Group"
  type        = number
  default     = 100
}

variable "alb_target_groups_health_check_protocol" {
  description = "The target health check protocol specified for the Target Group"
  type        = string
  default     = "HTTP"
}

variable "alb_target_groups_health_check_matcher" {
  description = "The target health check matcher specified for the Target Group"
  type        = string
  default     = "200-399"
}

variable "alb_target_groups_http_tcp_listeners_port" {
  description = "The port specified for the http tcp listeners"
  type        = number
  default     = 80
}

variable "alb_target_groups_http_tcp_listeners_protocol" {
  description = "The protocol specified for the http tcp listeners"
  type        = string
  default     = "HTTP"
}

variable "alb_target_groups_http_tcp_listeners_target_group_index" {
  description = "The target group index specified for the http tcp listeners"
  type        = number
  default     = 0
}

variable "alb_target_groups_http_tcp_listeners_action_type" {
  description = "The action type specified for the http tcp listeners"
  type        = string
  default     = "forward"
}

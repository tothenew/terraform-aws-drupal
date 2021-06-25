#ASG Variables

variable "target_group_drupal" {
  default = null
}

variable "asg_subnet_drupal" {
  description = "A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with `availability_zones`"
  type        = list(string)
}

variable "asg_sec_group_drupal" {
  description = "A list of security group IDs to associate"
  type        = string
}

variable "asg_name" {
  description = "Name used across the resources created"
  type        = string
}

variable "asg_min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number
}

variable "asg_max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
}

variable "asg_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
  type        = number
}

variable "asg_wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  type        = string
}

variable "asg_health_check_type" {
  description = "`EC2` or `ELB`. Controls how health checking is done"
  type        = string
}

variable "asg_lt_name" {
  description = "Name of launch template to be created"
  type        = string
}

variable "asg_description" {
  description = "(LT) Description of the launch template"
  type        = string
}

variable "asg_use_lt" {
  description = "Determines whether to use a launch template in the autoscaling group or not"
  type        = bool
}

variable "asg_create_lt" {
  description = "Determines whether to create launch template or not"
  type        = bool
}

variable "asg_image_id" {
  description = "The AMI from which to launch the instance"
  type        = string
}

variable "asg_instance_type" {
  description = "The type of the instance to launch"
  type        = string
}

variable "asg_key_name" {
  description = "The key name that should be used for the instance"
  type        = string
}

variable "asg_health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
}


#DB Variables

variable "rds_sec_group_drupal" {
  description = "A list of VPC subnet IDs"
  type        = string
}

variable "rds_subnet_drupal" {
  description = "List of VPC security groups to associate"
  type        = list(string)
}

variable "rds_identifier_source" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
}

variable "rds_engine" {
  description = "The database engine to use"
  type        = string
}

variable "rds_engine_version" {
  description = "The engine version to use"
  type        = string
}

variable "rds_instance_class_source" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "rds_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
}

variable "rds_max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
}

variable "rds_name_source" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
}

variable "rds_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "rds_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
}

variable "rds_port" {
  description = "The port on which the DB accepts connections"
  type        = string
}

variable "rds_parameter_group_name" {
  description = "Name of the DB parameter group to associate or create"
  type        = string
}

variable "rds_create_db_parameter_group" {
  description = "Whether to create a database parameter group"
  type        = bool
}

variable "rds_create_db_option_group" {
  description = "Create a database option group"
  type        = bool
}

variable "rds_maintenance_window_source" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
}

variable "rds_backup_window_source" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
}

variable "rds_backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
}

variable "rds_skip_final_snapshot_source" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
}

variable "rds_identifier_read" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
}

variable "rds_name_read" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
}

variable "rds_instance_class_read" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "rds_maintenance_window_read" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
}

variable "rds_backup_window_read" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
}

variable "rds_skip_final_snapshot_read" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
}

variable "rds_create_db_subnet_group" {
  description = "Whether to create a database subnet group"
  type        = bool
}


#EFS Variables

variable "efs_vpc_drupal" {
  description = "VPC ID"
  type        = string
}

variable "efs_subnet_drupal" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "efs_sec_group_drupal" {
  description = "A list of Security Group IDs to associate with EFS"
  type        = string
}

variable "efs_namespace" {
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
  type        = string
}

variable "efs_stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
  type        = string
}

variable "efs_name" {
  description = "Solution name, e.g. 'app' or 'jenkins'"
  type        = string
}

variable "efs_region" {
  description = "AWS Region"
  type        = string
}


#ALB Variables

variable "alb_vpc_drupal" {
  description = "VPC ID"
  type        = string
}

variable "alb_subnet_drupal" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "alb_sec_group_drupal" {
  description = "The security groups to attach to the load balancer."
  type        = string
}

variable "alb_name" {
  description = "The resource name and Name tag of the load balancer."
  type        = string
}

variable "alb_load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application or network."
  type        = string
}

variable "alb_target_groups_name" {
  description = "The name tag for the target group of the load balancer."
  type        = string
}

variable "alb_target_groups_backend_protocol" {
  description = "The protocol specified for the Target Group"
  type        = string
}

variable "alb_target_groups_backend_port" {
  description = "The port specified for the Target Group"
  type        = number
}

variable "alb_target_groups_target_type" {
  description = "The target type specified for the Target Group"
  type        = string
}

variable "alb_target_groups_health_check_enabled" {
  description = "The health check specified for the Target Group"
  type        = bool
}

variable "alb_target_groups_health_check_interval" {
  description = "The target health check interval specified for the Target Group"
  type        = number
}

variable "alb_target_groups_health_check_path" {
  description = "The target health check path specified for the Target Group"
  type        = string
}

variable "alb_target_groups_health_check_port" {
  description = "The target health check path specified for the Target Group"
  type        = string
}

variable "alb_target_groups_health_check_healthy_threshold" {
  description = "The target health check healthy threshold specified for the Target Group"
  type        = number
}

variable "alb_target_groups_health_check_unhealthy_threshold" {
  description = "The target health check unhealthy threshold specified for the Target Group"
  type        = number
}

variable "alb_target_groups_health_check_timeout" {
  description = "The target health check timeout specified for the Target Group"
  type        = number
}

variable "alb_target_groups_health_check_protocol" {
  description = "The target health check protocol specified for the Target Group"
  type        = string
}

variable "alb_target_groups_health_check_matcher" {
  description = "The target health check matcher specified for the Target Group"
  type        = string
}

variable "alb_target_groups_http_tcp_listeners_port" {
  description = "The port specified for the http tcp listeners"
  type        = number
}

variable "alb_target_groups_http_tcp_listeners_protocol" {
  description = "The protocol specified for the http tcp listeners"
  type        = string
}

variable "alb_target_groups_http_tcp_listeners_target_group_index" {
  description = "The target group index specified for the http tcp listeners"
  type        = number
}

variable "alb_target_groups_http_tcp_listeners_action_type" {
  description = "The action type specified for the http tcp listeners"
  type        = string
}

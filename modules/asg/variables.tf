variable "db_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "db_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
}

variable "name" {
  description = "Name used across the resources created"
  type        = string
  default     = "demo-testing"
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
  type        = number
  default     = 2
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  type        = string
  default     = "5m"
}

variable "health_check_type" {
  description = "`EC2` or `ELB`. Controls how health checking is done"
  type        = string
  default     = "EC2"
}

variable "lt_name" {
  description = "Name of launch template to be created"
  type        = string
  default     = "foobar"
}

variable "description" {
  description = "(LT) Description of the launch template"
  type        = string
  default     = "Complete launch template example"
}

variable "use_lt" {
  description = "Determines whether to use a launch template in the autoscaling group or not"
  type        = bool
  default     = true
}

variable "create_lt" {
  description = "Determines whether to create launch template or not"
  type        = bool
  default     = true
}

variable "image_id" {
  description = "The AMI from which to launch the instance"
  type        = string
  default     = "ami-042be016955b1914d"
}

variable "instance_type" {
  description = "The type of the instance to launch"
  type        = string
  default     = "t3a.medium"
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  type        = string
  default     = "pratishtha-testing"
}

variable "subnet_asg" {
  description = "A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with `availability_zones`"
  type        = list(string)
  default     = null
}

variable "sec_group_asg" {
  description = "A list of security group IDs to associate"
  type        = string
  default     = null
}

variable "target_gp" {
  description = "A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing"
  type        = list(string)
  default     = null
}

variable "rds_point" {
  description = "The connection endpoint used in ASG"
  type        = string
  default     = null
}

variable "dns_name" {
  description = "EFS DNS name used in ASG"
  type        = string
  default     = null
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "rolearn" {
  description = "ARN of IAM role"
  default     = null
}

variable "installTelegrafCW" {
  description = "Whether the user wants to install Telegraf or not"
  type        = bool
}

variable "installFluentbitCW" {
  description = "Whether the user wants to install Fluentbit or not"
  type        = bool
}

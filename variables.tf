variable "vpc_drupal" {

}

variable "sec_group_drupal_rds" {

}

variable "subnet_drupal_rds" {

}

variable "subnet_drupal_asg" {

}

variable "sec_group_drupal_asg" {

}

variable "vpc_drupal_alb" {

}

variable "sec_group_drupal_alb" {

}

variable "subnet_drupal_alb" {

}

variable "subnet_drupal_efs" {

}

variable "sec_group_drupal_efs" {

}

variable "vpc_drupal_efs" {

}

variable "target_group_drupal" {
  default = null

}

#variable "create" {
#  description = "Whether to create this resource or not?"
#  type        = bool
#  default     = true
#}

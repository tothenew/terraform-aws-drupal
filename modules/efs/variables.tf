variable "vpc_efs" {
  description = "VPC ID"
  type        = string
  default     = null
}

variable "subnet_efs" {
  description = "Subnet IDs"
  type        = list(string)
  default     = null
}

variable "sec_group_efs" {
  description = "A list of Security Group IDs to associate with EFS"
  type        = string
  default     = null
}

variable "namespace" {
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
  type        = string
  default     = "demo-efs"
}

variable "stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
  type        = string
  default     = "test"
}

variable "name" {
  description = "Solution name, e.g. 'app' or 'jenkins'"
  type        = string
  default     = "app"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

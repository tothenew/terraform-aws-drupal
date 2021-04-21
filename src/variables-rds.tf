/* ****************************************
  RDS Aurora instance variables
***************************************** */
variable "db-subnet-name" {}
variable "db-subnet-ids" {}
variable "allocated_storage" {}
variable "backup_retention_period" {}
variable "engine" {}
variable "engine_version" {}
variable "license_model" {}
variable "identifier" {}
variable "instance_class" {}
variable "multi_az" {}
variable "db-name" {}
variable "db-port" {}
variable "publicly_accessible" {}
variable "storage_encrypted" {}
variable "storage_type" {}
variable "db-username" {}
variable "vpc_security_group_ids" {}
variable "skip_final_snapshot" {}
variable "cidr_blocks" {}
variable "max_allocated_storage" {}
variable "allow_major_version_upgrade" {}
variable "auto_minor_version_upgrade" {}
variable "apply_immediately" {}


variable "identifier_source" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
  default     = "mysql-source"
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "5.7"
}

variable "instance_class_source" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
  default     = 50
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 100
}

variable "name_source" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = "mydb_source"
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = "drupaladmin"
}

variable "password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  default     = "redhat22"
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = 3306
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate or create"
  type        = string
  default     = "default.mysql5.7"
}

variable "create_db_parameter_group" {
  description = "Whether to create a database parameter group"
  type        = bool
  default     = false
}

variable "create_db_option_group" {
  description = "Create a database option group"
  type        = bool
  default     = false
}

variable "maintenance_window_source" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "Sun:05:00-Sun:06:00"
}

variable "backup_window_source" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = "09:46-10:16"
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 10
}

variable "skip_final_snapshot_source" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = true
}

variable "create_db_subnet_group" {
  description = "Whether to create a database subnet group"
  type        = bool
  default     = false
}

variable "subnet_rds" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = null
}

variable "sec_group_rds" {
  description = "List of VPC security groups to associate"
  type        = string
  default     = null
}

variable "identifier_read" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
  default     = "mysql-read"
}

variable "name_read" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = "mydb_read"
}

variable "instance_class_read" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "maintenance_window_read" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "Sun:05:00-Sun:06:00"
}

variable "backup_window_read" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = "09:46-10:16"
}

variable "skip_final_snapshot_read" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = true
}

variable "createRDSReadReplica" {
  description = "Whether the user wants to create Read Replica or not"
  type        = bool
}

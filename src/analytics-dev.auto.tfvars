
/* ****************************************
 RDS Setup Variable Values
***************************************** */

backup_retention_period     = "7"
engine                      = "mysql"
engine_version              = "8.0.21"
license_model               = "general-public-license"
identifier                  = "test-dev"
instance_class              = "db.r5.large"
multi_az                    = false
db-name                     = "test"
db-port                     = "3306"
publicly_accessible         = false
storage_encrypted           = true
skip_final_snapshot         = true
storage_type                = "gp2"
db-username                 = "admin"
cidr_blocks                 = ["10.144.32.0/20", "10.145.0.25/32",]
max_allocated_storage       = 1000
allow_major_version_upgrade = true
auto_minor_version_upgrade  = true
apply_immediately           = true

resource "aws_security_group" "rds-mysql-sg" {
  name        = "rds-mysql-sg"
  description = "rds security group"
  vpc_id      = data.aws_ssm_parameter.vpc.value
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    #tfsec:ignore:AWS009
    cidr_blocks = ["0.0.0.0/0"]
  }
}

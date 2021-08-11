module "aws_efs" {
  source = "git@github.com:cloudposse/terraform-aws-efs.git?ref=tags/0.30.1"

  namespace       = var.namespace
  stage           = var.stage
  name            = var.name
  region          = var.region
  vpc_id          = var.vpc_efs
  subnets         = var.subnet_efs
  security_groups = [var.sec_group_efs]
}

output "dns_name_efs" {
  value = module.aws_efs.dns_name
}

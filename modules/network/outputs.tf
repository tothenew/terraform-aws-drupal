output "vpc_id_all" {
  value = module.vpc.vpc_id
}

output "public_sn_asg" {
  value = module.vpc.public_subnets
}

output "private_sn_asg" {
  value = module.vpc.public_subnets
  #value = flatten(module.vpc.private_subnets)[2]
}

output "security_group_id_asg" {
  value = module.security_group_asg.security_group_id
}

output "security_group_id_rds" {
  value = module.security_group_rds.security_group_id
}

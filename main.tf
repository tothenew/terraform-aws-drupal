module "db" {
  source        = "./modules/db/"
  vpc_asg       = module.network.vpc_id_all
  sec_group_rds = module.network.security_group_id_rds
  subnet_rds    = module.network.public_sn_asg
}

module "asg" {
  source        = "./modules/asg/"
  subnet_asg    = module.network.public_sn_asg
  sec_group_asg = module.network.security_group_id_asg
  rds_point     = module.db.rds_endpoint
  depends_on    = [module.db.rds_endpoint]
  target_gp     = module.alb.tg
  dns_name      = module.efs.dns_name_efs
}

module "network" {
  source = "./modules/network/"
}

module "alb" {
  source        = "./modules/alb/"
  vpc_alb       = module.network.vpc_id_all
  sec_group_alb = module.network.security_group_id_asg
  subnet_alb    = module.network.public_sn_asg
}

module "efs" {
  source        = "./modules/efs/"
  subnet_efs    = module.network.private_sn_asg
  sec_group_efs = module.network.security_group_id_asg
  vpc_efs       = module.network.vpc_id_all
}

module "route53" {
  source      = "./modules/route53/"
  dns_alb     = module.alb.alb_dns
  vpc_route53 = module.network.vpc_id_all
}

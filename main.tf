module "db" {
  source        = "./modules/db/"
  vpc_asg       = var.vpc_drupal
  sec_group_rds = var.sec_group_drupal_rds
  subnet_rds    = var.subnet_drupal_rds
}

module "asg" {
  source = "./modules/asg/"
  #subnet_asg    = var.demo
  subnet_asg    = var.subnet_drupal_asg
  sec_group_asg = var.sec_group_drupal_asg
  rds_point     = module.db.rds_endpoint
  depends_on    = [module.db.rds_endpoint]
  target_gp     = module.alb.tg
  dns_name      = module.efs.dns_name_efs
}

module "alb" {
  source        = "./modules/alb/"
  vpc_alb       = module.network.vpc_id_all
  sec_group_alb = module.network.security_group_id_asg
  subnet_alb    = module.network.public_sn_asg
}

module "efs" {
  source        = "./modules/efs/"
  subnet_efs    = var.subnet_drupal_efs
  sec_group_efs = var.sec_group_drupal_efs
  vpc_efs       = var.vpc_drupal_efs
}

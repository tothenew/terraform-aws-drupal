module "db" {
  source        = "./modules/db/"
  vpc_asg       = var.vpc_drupal
  sec_group_rds = var.sec_group_drupal_rds
  subnet_rds    = var.subnet_drupal_rds
}

module "asg" {
  source = "./modules/asg/"

  subnet_asg    = var.subnet_drupal_asg
  sec_group_asg = var.sec_group_drupal_asg

  rds_point  = module.db.rds_endpoint
  depends_on = [module.db.rds_endpoint]

  target_gp = var.target_group_drupal != null ? var.target_group_drupal : module.alb[0].target_group_arns

  #target_gp  = module.alb.tg
  dns_name = module.efs.dns_name_efs
}

module "alb" {
  count = var.target_group_drupal == null ? 1 : 0

  source = "git@github.com:terraform-aws-modules/terraform-aws-alb.git?ref=v6.0.0"

  name = "demo-alb"

  load_balancer_type = "application"

  vpc_id          = var.vpc_drupal_alb
  subnets         = var.subnet_drupal_alb
  security_groups = [var.sec_group_drupal_alb]

  target_groups = [
    {
      name             = "target-group"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 110
        path                = "/drupal"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 100
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "forward"
    }
  ]

  tags = {
    Project = "terraform_drupal"
    Name    = "terraform_asg_cluster"
    BU      = "demo-testing"
    Owner   = "pratishtha.verma@tothenew.com"
    Purpose = "gtihub project"
  }
}

module "efs" {
  source        = "./modules/efs/"
  subnet_efs    = var.subnet_drupal_efs
  sec_group_efs = var.sec_group_drupal_efs
  vpc_efs       = var.vpc_drupal_efs
}

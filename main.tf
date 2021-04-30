module "db" {
  source = "./modules/db/"
}

module "asg" {
  source = "./modules/asg/"
}

module "alb" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-alb.git?ref=v6.0.0"

  name = "demo-alb"

  load_balancer_type = "application"

  vpc_id          = "vpc-5bc36a26"
  subnets         = ["subnet-800499e6", "subnet-d7cc6ce6"]
  security_groups = ["sg-476ef04a"]

  target_groups = [
    {
      name             = "target-group"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = "i-063d2faf12dc55f37"
          port      = 80
        }
      ]
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

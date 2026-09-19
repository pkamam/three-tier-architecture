module "web_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = "three-tier-webServer-alb"

  load_balancer_type = "application"

  internal = false

  vpc_id = module.vpc.vpc_id

  subnets = module.vpc.public_subnets

  security_groups = [
    module.web_security_group.security_group_id
  ]

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "web"
      }
    }
  }

  target_groups = {
    web = {
      name_prefix = "three-"

      protocol = "HTTP"
      port     = 80

      target_type = "instance"

      create_attachment = false

      health_check = {
        enabled             = true
        healthy_threshold   = 2
        unhealthy_threshold = 2
        interval            = 30
        timeout             = 5
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

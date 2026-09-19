module "web_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "three-tier-webServer-sg"
  description = "Security group for three tier architecture web servers"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "ssh-tcp",
    "http-80-tcp",
    "https-443-tcp"
  ]

  egress_rules = [
    "all-all"
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

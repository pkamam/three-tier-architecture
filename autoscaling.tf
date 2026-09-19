module "web_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 8.0"

  name = "three-tier-webServer-asg"

  min_size         = 2
  max_size         = 5
  desired_capacity = 2

  vpc_zone_identifier = module.vpc.public_subnets

  health_check_type = "ELB"

  health_check_grace_period = 300

  # Launch Template
  image_id      = data.aws_ssm_parameter.amazon_linux_2.value
  instance_type = "t2.micro"

  key_name = "user1"

  security_groups = [
    module.web_security_group.security_group_id
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash

    yum update -y
    yum install -y httpd

    systemctl enable httpd
    systemctl start httpd

    echo "<h1>Three tier Architecture Web Server</h1>" > /var/www/html/index.html
    echo "<p>Hostname: $(hostname)</p>" >> /var/www/html/index.html
  EOF
  )

  # Attach ASG to ALB target group
  traffic_source_attachments = {
    web = {
      traffic_source_identifier = module.web_alb.target_groups["web"].arn
      traffic_source_type       = "elbv2"
    }
  }

  # CPU scaling
  autoscaling_group_tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  scaling_policies = {
    cpu = {
      policy_type = "TargetTrackingScaling"

      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }

        target_value = 50.0
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

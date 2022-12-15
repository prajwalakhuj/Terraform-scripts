provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "/home/ubuntu/.aws/credentials"
}
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "prajwal-alb-tf"

  load_balancer_type = "application"

  vpc_id             = "vpc-0d3fee4b9a82341f3"
  subnets            = ["subnet-08b59fb054dbba0dd", "subnet-0e5794508390edf53"]
  security_groups    = ["sg-0bdace4237eb8e231"]

  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:acm:us-east-2:421320058418:certificate/4592b34b-641e-4dcf-8309-50dc217eb1bd"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}

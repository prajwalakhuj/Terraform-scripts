## Load Balancer [ALB]
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "prajwal-alb-nodejs"
  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [resource.aws_security_group.prajwal-sg-lb.id]

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
    env = "dev"
    Name = "prajwal-tg"
  }
}

## SG for ALB
resource "aws_security_group" "prajwal-sg-lb" {
  name        = "prajwal-sg-lb"
  description = "Allow TLS inbound and outbund traffic"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "prajwal-sg-lb"
    owner = "prajwal"
    env = "dev"
    terraform = true
  }
}

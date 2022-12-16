# Autoscaling group

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"

  name = "prajwal-asg-nodejs"

  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name        = "prajwal-lt-nodejs"
  launch_template_description = "Launch template example"
  update_default_version      = true

  image_id          = "ami-0e732cd0d23181a6e"
  instance_type     = "t3a.small"
  key_name          = "prajwal-key-aws"
  ebs_optimized     = true
  enable_monitoring = true
  target_group_arns = module.alb.target_group_arns
  iam_instance_profile_name = "codedeploy_role_for_ec2"

  tags = {
    env = "dev"
    owner = "prajwal"
  }
}

# Scaling Policy
resource "aws_autoscaling_policy" "asg-policy" {
  count                     = 1
  name                      = "asg-cpu-policy"
  autoscaling_group_name    = module.asg.autoscaling_group_name
  estimated_instance_warmup = 60
  policy_type               = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

## Security Group for NodeApp Instance

resource "aws_security_group" "prajwal-sg-nodejs" {
  name        = "prajwal-sg-nodejs"
  description = "Allow TLS inbound and outbund traffic"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.prajwal-sg-vpn.id]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    security_groups = [aws_security_group.prajwal-sg-lb.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "prajwal-sg-nodejs"
    owner = "prajwal"
    env = "dev"
    terraform = true
  }
}

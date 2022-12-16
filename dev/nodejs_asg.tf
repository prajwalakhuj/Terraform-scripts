module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"

  name = "prajwal-terraform-asg"

  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = ["subnet-042226291355f1e2e", "subnet-03e7c87961503394b"]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 60
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name        = "prajwal-tf-template"
  launch_template_description = "Tf Launch template example"
  update_default_version      = true

  image_id          = "ami-0e732cd0d23181a6e"
  instance_type     = "t3a.small"
  key_name          = "prajwal-key-aws"
  ebs_optimized     = true
  enable_monitoring = true
  iam_instance_profile_name = "codedeploy_role_for_ec2"

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "prajwal-tf-asg"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role example"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = {
    Name = "prajwal-tf-asg"
  }
}

# Scaling Policy
resource "aws_autoscaling_policy" "asg-policy" {
  count                     = 1
  name                      = "prajwal-asg-cpu-policy"
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

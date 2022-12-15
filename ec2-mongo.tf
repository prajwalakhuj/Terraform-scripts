provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "/home/ubuntu/.aws/credentials"
}
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["one", "two", "three"])

  name = "instance-${each.key}"

  ami                    = "ami-0ada6d94f396377f2"
  instance_type          = "t3a.small"
  key_name               = "prajwal-key-aws"
  monitoring             = true
  vpc_security_group_ids = ["sg-0becefa2f91268c71"]
  subnet_id              = "subnet-0645e4537053c3d0a"

  tags = {
    Terraform   = "true"
    Environment = "test"
  }
}

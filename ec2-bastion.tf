provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "/home/ubuntu/.aws/credentials"
}
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "prajwal-bastion-tf"

  ami                    = "ami-0ada6d94f396377f2"
  instance_type          = "t3a.small"
  key_name               = "prajwal-key-aws"
  monitoring             = true
  vpc_security_group_ids = ["sg-098af3f46282f01fc"]
  subnet_id              = "subnet-08b59fb054dbba0dd"

  tags = {
    Terraform   = "true"
    Environment = "test"
  }
}

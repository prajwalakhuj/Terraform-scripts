provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "/home/ubuntu/.aws/credentials"
}
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["mongodb-1", "mongodb-2", "mongodb-3"])

  name = "prajwal-${each.key}"

  ami                    = "ami-0ada6d94f396377f2"
  instance_type          = "t3a.small"
  key_name               = "prajwal-key-aws"
  monitoring             = true
  vpc_security_group_ids = ["sg-0becefa2f91268c71"]
  subnet_id              = "subnet-042226291355f1e2e"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "/home/ubuntu/.aws/credentials"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "prajwal-vpc"
  cidr = "30.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b",]
  private_subnets = ["30.0.1.0/24", "30.0.2.0/24",]
  public_subnets  = ["30.0.101.0/24", "30.0.102.0/24",]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

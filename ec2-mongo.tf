## Three mongodb instances

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["mongodb-0", "mongodb-1", "mongodb-2"])

  name = "prajwal-${each.key}"

  ami                    = "ami-0ada6d94f396377f2"
  instance_type          = "t3a.small"
  key_name               = "prajwal-key-aws"
  monitoring             = true
  vpc_security_group_ids = [resource.aws_security_group.prajwal-sg-mongo.id]
  subnet_id              = module.vpc.private_subnets[0]
  
  tags = {
    Terraform   = "true"
    Environment = "dev"
    owner = "prajwal"
  }
}

## Security Group of Mongo Instances
resource "aws_security_group" "prajwal-sg-mongo" {
  name        = "prajwal-sg-mongo-tf"
  description = "Allow TLS inbound and outbund traffic"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [module.vpc.vpc_cidr_block]
  }
 ingress {
    description      = "TLS from VPC"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    cidr_blocks      = [module.vpc.vpc_cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "prajwal-sg-mongo"
    owner = "prajwal"
    env = "dev"
    terraform = true
  }
}


## Bastion host instance for ssh to mongo servers
module "ec2_instance_bastion"   {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "prajwal-bastion-tf"

  ami                    = "ami-0ada6d94f396377f2"
  instance_type          = "t3a.small"
  key_name               = "prajwal-key-aws"
  monitoring             = true
  vpc_security_group_ids = [resource.aws_security_group.prajwal-sg-bastion.id]
  subnet_id              = module.vpc.public_subnets[0]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

## Security Group of Bastion host
resource "aws_security_group" "prajwal-sg-bastion" {
  name        = "prajwal-sg-bastion-tf"
  description = "Allow TLS inbound and outbund traffic"
  vpc_id      = module.vpc.vpc_id

 ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
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
    Name = "prajwal-sg-bastion"
    owner = "prajwal"
    terraform = true
    env = "dev"
 }
}

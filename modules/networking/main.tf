# dynamically retrieves availability zones
data "aws_availability_zones" "available" {}

# call the vpc module to be imported with the terraform init command, the module link provides documentation on the vpc module "terraform-aws-modules/vpc/aws".
module "vpc" {
  source = "terraform-aws-modules/vpc/aws" #path from registry .if it were local we would have written "./terraform-aws-modules/vpc/aws"
  name = "${var.namespace}-vpc"
  cidr = "10.0.0.0/16"
  azs = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  #assign_generated_ipv6_cidr_block = true
  create_database_subnet_group = true
  enable_nat_gateway = true
  single_nat_gateway = true
}

# SG to authorize SSH connections from any host
resource "aws_security_group" "allow_ssh_pub" {
  name = "${var.namespace}-allow_ssh"
  description = "Allow incoming SSH and HTTP traffic"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "SSH from Internet
    from_port = 22
    to_port = 22
    protocol = "tcp
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from Internet"
    from_port = 80
    to_port = 80
    protocol = "tcp
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.namespace}-allow_ssh_pub"
  }
}

#SG to allow SSH connections only from VPC public subnets
resource "aws_security_group" "allow_ssh_priv" {
  name = "${var.namespace}-allow_ssh_priv"
  description = "Allow incoming SSH traffic"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "SSH from internal VPC clients only"
    from_port = 22
    to_port = 22
    protocol = "tcp
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    description = "HTTP from internal VPC clients only"
    from_port = 80
    to_port = 80
    protocol = "tcp
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-allow_ssh_priv"
  }
}
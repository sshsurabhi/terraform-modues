provider "aws" {
  region     = "eu-west-3"
  access_key = "XXXXXXXXXXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Call the networking module
module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace
}

# Call the EC2 module
module "ec2" {
  source    = "./modules/ec2"
  namespace = var.namespace
  vpc       = module.networking.vpc
  sg_pub_id = module.networking.sg_pub_id
  sg_priv_id = module.networking.sg_priv_id
  key_name  = "Datascientest"
}
variable "namespace" {
  type = string
}

Copy the following content into the file outputs.tf

output "vpc" {
  value = module.vpc
}

output "sg_pub_id" {
  value = aws_security_group.allow_ssh_pub.id
}

output "sg_priv_id" {
  value = aws_security_group.allow_ssh_priv.id
}
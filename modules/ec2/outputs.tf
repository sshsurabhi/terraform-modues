# deployment environment
variable "namespace" {
  type = string
}
# VPC
variable "vpc" {
  type = any
}
# key pair used
variable key_name {
  type = string
}
# public security group id
variable "sg_pub_id" {
  type = any
}
# private security group id
variable "sg_priv_id" {
  type = any
}
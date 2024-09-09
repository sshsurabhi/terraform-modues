variable "namespace" {
  description = "The project namespace to be used for the unique naming of resources"
  default     = "Datascientest"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "eu-west-3"
  type        = string
}
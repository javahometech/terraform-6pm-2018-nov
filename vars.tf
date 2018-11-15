variable "region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_tenancy" {
  default = "default"
}

variable "azs" {
  type    = "list"
  default = ["ap-south-1a", "ap-south-1b"]
}

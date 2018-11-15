provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "javahome-6pm-state"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
  }
}

resource "aws_vpc" "manual_vpc" {
  cidr_block       = "10.20.0.0/16"
  instance_tenancy = "default"

  tags {
    Name  = "one"
    batch = "6PM"
  }
}

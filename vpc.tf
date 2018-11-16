locals {
  web_sub_ids = "${aws_subnet.webservers.*.id}"
}

resource "aws_vpc" "myapp" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "${var.vpc_tenancy}"

  tags {
    Name = "myapp_vpc"
  }
}

# Add public subnets, make sure each zone have one subnet

resource "aws_subnet" "webservers" {
  count      = "${length(data.aws_availability_zones.azs.names)}"
  vpc_id     = "${aws_vpc.myapp.id}"
  cidr_block = "${var.web_cidrs[count.index]}"

  tags {
    Name = "Webservers-${count.index + 1}"
  }
}

# Add Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.myapp.id}"

  tags {
    Name = "myapp_igw"
  }
}

# Create Route table for webservers
resource "aws_route_table" "web_rt" {
  vpc_id = "${aws_vpc.myapp.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "WebserversRT"
  }
}

# Attavh web_rt with Webservers subenets

resource "aws_route_table_association" "web_rt" {
  count          = "${length(local.web_sub_ids)}"
  subnet_id      = "${local.web_sub_ids[count.index]}"
  route_table_id = "${aws_route_table.web_rt.id}"
}

# Create 2 private subnets
resource "aws_subnet" "rds" {
  count      = "2"
  vpc_id     = "${aws_vpc.myapp.id}"
  cidr_block = "${var.rds_cidrs[count.index]}"

  tags {
    Name = "RDS-${count.index + 1}"
  }
}

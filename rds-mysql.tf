# Group of private subnets to launch RDS
resource "aws_db_subnet_group" "rds_subnets" {
  name       = "rds_subnets"
  subnet_ids = ["${aws_subnet.rds.*.id}"]

  tags {
    Name = "subnet group for RDS"
  }
}

# Launch RDS

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "javahomedb"
  username             = "javahomedb"
  password             = "javahomedb"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = "${aws_db_subnet_group.rds_subnets.id}"
}

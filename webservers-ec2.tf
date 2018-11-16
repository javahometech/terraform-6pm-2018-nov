resource "aws_instance" "web" {
  count         = 2
  ami           = "${var.web_ami[var.region]}"
  instance_type = "t2.micro"
  subnet_id     = "${local.web_sub_ids[count.index]}"

  tags {
    Name = "Web-${count.index + 1}"
  }
}

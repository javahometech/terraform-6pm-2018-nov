# Webservers in public subnet
resource "aws_instance" "web" {
  count                  = 2
  ami                    = "${var.web_ami[var.region]}"
  instance_type          = "t2.micro"
  subnet_id              = "${local.web_sub_ids[count.index]}"
  vpc_security_group_ids = ["${aws_security_group.web_sg.id}"]
  user_data              = "${file("scripts/apache.sh")}"
  key_name               = "aws"
  iam_instance_profile   = "${aws_iam_instance_profile.test_profile.name}"

  tags {
    Name = "Web-${count.index + 1}"
  }
}

# Configure sercurity group for webservers

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow ssh and httpd inbound traffic"
  vpc_id      = "${aws_vpc.myapp.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

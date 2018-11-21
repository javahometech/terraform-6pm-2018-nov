# Create a new load balancer
resource "aws_elb" "6pm_elb" {
  name    = "6pm-terraform-elb"
  subnets = ["${local.web_sub_ids}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  instances                   = ["${aws_instance.web.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 60
  security_groups             = ["${aws_security_group.elb_sg.id}"]

  tags {
    Name = "6pm-terraform-elbb"
  }
}

# Security Group for ELB

resource "aws_security_group" "elb_sg" {
  name        = "elb-sg"
  description = "Allow ssh and httpd inbound traffic"
  vpc_id      = "${aws_vpc.myapp.id}"

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

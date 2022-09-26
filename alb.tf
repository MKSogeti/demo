# Target group
resource "aws_lb_target_group" "demo" {
  name     = "demo-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo.id


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    interval            = 30
    path                = "/"
  }

}


# Attachment
resource "aws_lb_target_group_attachment" "demo" {
  count            = var.web_ec2_count
  target_group_arn = aws_lb_target_group.demo.arn
  target_id        = aws_instance.web.*.id[count.index]
  port             = 80
}


# Create ALB
resource "aws_lb" "demo" {
  name               = "demo-lb-tf"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.elb_sg.id}"]
  subnets            = local.pub_sub_ids


  access_logs {
    bucket  = "demo-hctra-alb-access-logs"
    prefix  = "demo"
    enabled = true
  }

  tags = {
    Environment = "${terraform.workspace}"
  }
}

# Listener

resource "aws_lb_listener" "web_tg" {
  load_balancer_arn = aws_lb.demo.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo.arn
  }
}


data "template_file" "demo" {
  template = file("scripts/iam/alb-s3-access-logs.json")
  vars = {
    access_logs_bucket = "demo-hctra-alb-access-logs"
  }
}


resource "aws_security_group" "elb_sg" {
  name        = "elb_sg"
  description = "Allow traffic for web apps on elb"
  vpc_id      = aws_vpc.demo.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
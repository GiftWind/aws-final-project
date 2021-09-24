resource "aws_lb" "load_balancer" {
  name = "load-balancer"
  load_balancer_type = "application"
  subnets = [aws_subnet.vpc_two_public_subnet.id, aws_subnet.vpc_two_public_subnet_two.id]
  security_groups = [aws_security_group.alb-sg.id]
}

resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
    port = 8888
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.lb-tg.arn
  }
}

resource "aws_security_group" "alb-sg" {
  name = "ALB-SG"
  vpc_id = aws_vpc.vpc_two.id
  ingress {
    from_port = 80
    to_port = 8888
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "lb-tg" {
  name     = "lb-tg"
  port     = 8888
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_two.id
}

resource "aws_lb_target_group_attachment" "first" {
  target_group_arn = aws_lb_target_group.lb-tg.arn
  target_id = aws_instance.private_instance_vpc_two.id
  port = 8888
}

resource "aws_lb_target_group_attachment" "second" {
  target_group_arn = aws_lb_target_group.lb-tg.arn
  target_id = aws_instance.private_instance_vpc_two_2.id
  port  = 8888
}


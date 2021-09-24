resource "aws_lb" "load_balancer" {
  name = "load balancer"
  load_balancer_type = "application"
  subnets = [aws_subnet.vpc_two_private_subnet.id, aws_subnet.vpc_two_private_subnet_two]
}

resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = 80
  protocol = "HTTP"
}
resource "aws_lb_target_group" "alb-target-group" {
  name     = "application-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc01.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 6
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "attach-app01" {
  target_group_arn = aws_lb_target_group.alb-target-group.arn
  target_id        = aws_instance.server01.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "attach-app02" {
  target_group_arn = aws_lb_target_group.alb-target-group.arn
  target_id        = aws_instance.server02.id
  port             = 80
}

##Listener
resource "aws_lb_listener" "alb-http-listener" {
  load_balancer_arn = aws_lb.application-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }
}

##Create the Load Balancer
resource "aws_lb" "application-lb" {
  name               = "application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg02.id]
  subnets            = [aws_subnet.Public_sub01.id, aws_subnet.Public_sub02.id]

  enable_deletion_protection = false

  tags = {
    Environment = "application-lb"
    Name        = "Application-lb"

  }
}
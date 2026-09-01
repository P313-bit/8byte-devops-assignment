resource "aws_lb" "app" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb.id]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "${var.project_name}-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    port                = "8080"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

resource "aws_lb_target_group_attachment" "app_1" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app_1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "app_2" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app_2.id
  port             = 8080
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

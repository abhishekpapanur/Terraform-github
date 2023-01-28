# --- loadbalancing/main.tf

resource "aws_lb" "abhi_lb" {
  name            = "abhi-loadbalancing"
  subnets         = var.public_subnets
  security_groups = [var.public_sg]
  idle_timeout    = 400

}

resource "aws_lb_target_group" "abhi_tg" {
  name     = "abhi-lb-tg-${substr(uuid(), 0, 3)}"
  port     = var.tg_port     #80
  protocol = var.tg_protocol #HTTP
  vpc_id   = var.vpc_id
  lifecycle {
    ignore_changes        = [name]
    create_before_destroy = true
  }
  health_check {
    healthy_threshold   = var.lb_healthy_threshold   #2
    unhealthy_threshold = var.lb_unhealthy_threshold #2
    timeout             = var.lb_timeout
    interval            = var.lb_interval

  }
}

resource "aws_lb_listener" "abhi_lb_listener" {
  load_balancer_arn = aws_lb.abhi_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.abhi_tg.arn
  }
}
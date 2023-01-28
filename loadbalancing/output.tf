output "lb_target_group_arn" {
  value = aws_lb_target_group.abhi_tg.arn
}

output "lb_endpoint" {
  value = aws_lb.abhi_lb.dns_name
}
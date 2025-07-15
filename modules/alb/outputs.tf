output "target_group_arn" {
  value = aws_lb_target_group.ecs_tg.arn
}

output "listener" {
  value = aws_lb_listener.app_listener
}

output "alb_dns" {
  value = aws_lb.app_alb.dns_name
}

# ---- compute/output.terraform 

output "instance" {
  value = aws_instance.abhi_node[*]

}

output "instance_port" {
  value = aws_lb_target_group_attachment.abhi_tg_attach[0].port
}
# --- networking/output.tf

output "vpc_id" {
  value = aws_vpc.abhi_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.abhi_rds_subnetgroup.*.name
}

output "db_security_group" {
  value = [aws_security_group.abhi_sg["rds"].id]
}

output "public_sg" {
  value = aws_security_group.abhi_sg["public"].id
}

output "public_subnets" {
  value = aws_subnet.abhi_public_subnet.*.id
}
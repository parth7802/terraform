output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "ecs_service_sg_id" {
  value = aws_security_group.ecs_service_sg.id
}

output "igw" {
  value = aws_internet_gateway.igw.id
}
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

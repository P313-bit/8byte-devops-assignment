output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

output "app_instance_ids" {
  description = "Application EC2 instance IDs"
  value = [
    aws_instance.app_1.id,
    aws_instance.app_2.id
  ]
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.app.dns_name
}

output "target_group_arn" {
  description = "Application target group ARN"
  value       = aws_lb_target_group.app.arn
}

output "rds_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "PostgreSQL RDS port"
  value       = aws_db_instance.postgres.port
}

output "rds_database" {
  description = "PostgreSQL database name"
  value       = aws_db_instance.postgres.db_name
}

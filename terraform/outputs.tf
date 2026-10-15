output "vpc_id" {
  description = "ID of the project VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "availability_zone" {
  description = "Availability Zone used by the project"
  value       = data.aws_availability_zones.available.names[0]
}
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}
output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

output "app_public_ip" {
  description = "Public IP of EC2 A"
  value       = aws_instance.app.public_ip
}

output "app_private_ip" {
  description = "Private IP of EC2 A"
  value       = aws_instance.app.private_ip
}

output "backend_private_ip" {
  description = "Private IP of EC2 B"
  value       = aws_instance.backend.private_ip
}

output "db_private_ip" {
  description = "Private IP of EC2 C"
  value       = aws_instance.db.private_ip
}

output "ssh_key_name" {
  description = "AWS SSH key pair name"
  value       = aws_key_pair.project.key_name
}

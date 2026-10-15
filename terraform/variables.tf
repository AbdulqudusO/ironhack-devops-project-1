variable "aws_region" {
  description = "AWS region for the project"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name used for resource tags"
  type        = string
  default     = "ironhack-voting-app"
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.20.2.0/24"
}
variable "ssh_cidr" {
  description = "Public IP allowed to SSH into the application host"
  type        = string
}
variable "instance_type" {
  description = "EC2 instance type used by the project"
  type        = string
  default     = "t3.micro"
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/ironhack-project.pub"
}

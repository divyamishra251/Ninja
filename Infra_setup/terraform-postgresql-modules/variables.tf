variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = "US.pem"
}

variable "my_ip" {
  description = "Your IP address for Bastion access"
  type        = string
  default     = "117.98.100.235/32"
}
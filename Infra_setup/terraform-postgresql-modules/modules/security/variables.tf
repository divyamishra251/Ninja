variable "vpc_id" {
  description = "The VPC ID where the security groups will be created"
  type        = string
}

variable "my_ip" {
  description = "Your public IP with CIDR suffix (e.g., 117.98.100.235/32) for SSH access to Bastion"
  type        = string
}

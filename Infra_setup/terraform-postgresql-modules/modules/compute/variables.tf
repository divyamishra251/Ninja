variable "bastion_sg_id" {
  description = "Security group ID for the Bastion Host"
  type        = string
}

variable "postgresql_sg_id" {
  description = "Security group ID for the PostgreSQL nodes"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for Bastion Host"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for PostgreSQL cluster"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

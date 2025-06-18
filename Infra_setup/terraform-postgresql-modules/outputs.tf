output "bastion_ip" {
  value = module.compute.bastion_ip
}

output "postgresql_ips" {
  value = module.compute.postgresql_ips
}
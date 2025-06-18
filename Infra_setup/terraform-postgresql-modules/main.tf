module "networking" {
  source     = "./modules/networking"
  vpc_cidr   = var.vpc_cidr
}

module "security" {
  source   = "./modules/security"
  vpc_id   = module.networking.vpc_id
  my_ip    = var.my_ip
}

module "compute" {
  source             = "./modules/compute"
  bastion_sg_id      = module.security.bastion_sg_id
  postgresql_sg_id   = module.security.postgresql_sg_id
  public_subnet_id   = module.networking.public_subnet_id
  private_subnet_id  = module.networking.private_subnet_id
  key_name           = var.key_name
}
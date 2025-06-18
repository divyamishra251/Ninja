data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "Bastion-Host"
  }
}

resource "aws_instance" "postgresql_cluster" {
  count                     = 3
  ami                       = data.aws_ami.ubuntu.id
  instance_type             = "t2.micro"
  subnet_id                 = var.private_subnet_id
  vpc_security_group_ids    = [var.postgresql_sg_id]
  key_name                  = var.key_name

  user_data = templatefile("${path.module}/replica.sh.tpl", {
    index = count.index
  })

  tags = {
    Name = "PostgreSQL-Node-${count.index + 1}"
    Role = "postgresql_role" 
  }
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "postgresql_ips" {
  value = aws_instance.postgresql_cluster[*].private_ip
}
# ---- compute/main.tf

data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "random_id" "abhi_node_id" {
  byte_length = 2
  count       = var.instance_count
  # keepers = {
  #   key_name = var.key_name
  # }
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

resource "aws_key_pair" "pc_auth" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh

}

# resource "local_file" "key" {
#   content  = tls_private_key.rsa.private_key_pem
#   filename = "tfkey"

# }

resource "aws_instance" "abhi_node" {
  count         = var.instance_count
  instance_type = var.instance_type
  ami           = data.aws_ami.server_ami.id

  tags = {
    Name = "abhi_node-${random_id.abhi_node_id[count.index].dec}"
  }

  key_name               = aws_key_pair.pc_auth.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnets[count.index]
  user_data = templatefile(var.user_data_path,
    {
      nodename    = "abhi-${random_id.abhi_node_id[count.index].dec}"
      db_endpoint = var.db_endpoint
      dbuser      = var.dbuser
      dbpass      = var.dbpassword
      dbname      = var.dbname
    }
  )
  root_block_device {
    volume_size = var.vol_size #10
  }
  # depends_on = [
  #   aws_key_pair.pc_auth
  # ]
}

resource "aws_lb_target_group_attachment" "abhi_tg_attach" {
  count            = var.instance_count
  target_group_arn = var.lb_target_group_arn
  target_id        = aws_instance.abhi_node[count.index].id
  port             = var.tg_port
}
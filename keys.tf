resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "aws_final_project_keys"
  public_key = tls_private_key.rsa_key.public_key_openssh
}

resource "local_file" "key-file" {
  content  = tls_private_key.rsa_key.private_key_pem
  filename = local.key-file

  provisioner "local-exec" {
    command = local.bash
  }

  provisioner "local-exec" {
    command = local.bash_ssh
  }
}

locals {
  key-file = pathexpand("~/.ssh/aws_final_project_keys.pem")
}

locals {
  bash     = "chmod 400 ${local.key-file}"
  bash_ssh = "eval `ssh-agent -s`; ssh-add ${local.key-file}; ssh-add -L"
}
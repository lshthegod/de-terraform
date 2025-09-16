resource "tls_private_key" "docker_make_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "docker_make_keypair" {
  key_name   = "docker_key"
  public_key = tls_private_key.docker_make_key.public_key_openssh
}

resource "local_file" "docker_downloads_key" {
  filename = "de-terraform.pem"
  content  = tls_private_key.docker_make_key.private_key_pem
}
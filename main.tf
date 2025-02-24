provider "aws" {
  region = var.region

}

resource "aws_instance" "ec2_instance" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web_sg.name]
  key_name        = aws_key_pair.my_key.key_name
  user_data       = <<-EOF
     #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              echo "<h1>Welcome to My Terraform Web Server</h1>" | sudo tee /var/www/html/index.html
              EOF
  tags = {
    Name = var.instance_name

  }
}

resource "aws_key_pair" "my_key" {
  key_name   = "terraform_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDauDIWsXD4eFZiDH4f+7XrqIdywSoZjO/J3RYUJ/vTVrMGAfMWOkq00xFmFgAKPm8DFlri5iXSZAI3Vr19Ddh5qJgsMsYZuKIdpP2tZNyW1dhtO4fw4LLS89KscynoAAD0Srn0L/iux4MQ+n+ToRVvGvO5wgzfpuO5k4/90YfQNB5lCODEYdgabZTQ0mg+5O9rdIvKd7N5+f79Z8Wnjt/LQ+PdbcRp4aOb8YWqQyn4a8HXh+pO1orjRwD7uL57vzA/TARfkHChnB3b8b4pjFfTb4QXv8dGcbMuJXMyFxZbEIyNt93z/iaJK9c6AHtJpPMOBbHRX3W7UIOxrxqr9o23"
}

resource "aws_security_group" "web_sg" {
  name        = "web_server_security_group"
  description = "Allow SSH inbound traffic, Application traffic for Ubuntu"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

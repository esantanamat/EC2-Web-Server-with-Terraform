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
  public_key = "insert-your-public-key-here" #you can hardcode it by pasting or doing file('path-here')
}

resource "aws_security_group" "web_sg" {
  name        = "web_server_security_group"
  description = "Allow SSH inbound traffic, Application traffic for Ubuntu"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip] #only you should ssh to the ec2 instace :), regardless, the priv key is there as added security
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

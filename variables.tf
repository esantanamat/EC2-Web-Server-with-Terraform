variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ami" {
  type    = string
  default = "ami-08c40ec9ead489470"

}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_name" {
  type    = string
  default = "ec2-instance"
}

variable "key_path" {
  type    = string
  default = "C:/Users/Admin/Downloads/aws-ubuntu-ec2-project.pub"
}

variable "my_ip" {
  type    = string
  default = "69.120.57.242/32"

}

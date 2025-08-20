variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "lab2-vpc"
}

variable "public_subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "az" {
  default = "us-east-1a"
}

variable "public_subnet_name" {
  default = "public-subnet"
}

variable "ami_id" {
  description = "ami-05ffe3c48a9991133"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "public_instance_name" {
  default = "PublicEC2"
}

variable "key_name" {
  default = "jenkins"
}

variable "security_group_name" {
  default = "lab2-sg"
}

variable "allow_ssh_port" {
  default = 22
}

variable "allow_http_port" {
  default = 80
}

variable "first_port" {
  default = 0
}

variable "last_port" {
  default = 65535
}

variable "bool" {
  default = true
  type = bool
}

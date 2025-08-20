provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = var.bool
  tags = {
    Name = var.public_subnet_name
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "public_sg" {
  name   = var.security_group_name
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.first_port
    to_port     = var.last_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.first_port
    to_port     = var.last_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}

resource "aws_instance" "Master" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = var.bool
  security_groups             = [aws_security_group.public_sg.id]
  key_name = var.key_name
   root_block_device {
    volume_size           = 30    
    volume_type           = "gp3" 
    delete_on_termination = true
  }
  tags = {
    Name = var.public_instance_name
  }
}

resource "aws_instance" "Worker1" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = var.bool
  security_groups             = [aws_security_group.public_sg.id]
  key_name = var.key_name
   root_block_device {
    volume_size           = 30    
    volume_type           = "gp3" 
    delete_on_termination = true
  }
  tags = {
    Name = "worker1"
  }
}

resource "aws_instance" "Worker2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = var.bool
  security_groups             = [aws_security_group.public_sg.id]
  key_name = var.key_name
   root_block_device {
    volume_size           = 30    
    volume_type           = "gp3" 
    delete_on_termination = true
  }
  tags = {
    Name = "worker2"
  }
}

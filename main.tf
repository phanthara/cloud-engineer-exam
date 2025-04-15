provider "aws" {
  region = "ap-southeast-1" 
}

# Default VPC
data "aws_vpc" "default" {
  default = true
}

# Subnet
data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "default_subnet" {
  id = data.aws_subnets.default_subnets.ids[0]
}
# Key Pair 
resource "aws_key_pair" "deployer" {
  key_name   = "terraform-key"
  public_key = file("/home/phanthara/terraform-project/mykey.pub")
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                         = "ami-0ba62214afa52bec4" # Amazon Linux 2 (ap-southeast-1)
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.default_subnet.id
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  user_data                   = file("user_data.sh")

  tags = {
    Name = "Terraform-Nginx"
  }
}

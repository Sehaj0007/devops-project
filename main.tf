provider "aws" {
  region = "ap-south-1"
}

locals {
  project_name = "nextread"
}

resource "aws_key_pair" "deployer" {
  key_name   = "${local.project_name}-key"
  public_key = file("jenkins-key.pub")
}

resource "aws_security_group" "allow_web_ssh" {
  name_prefix = "${local.project_name}-sg-"
  description = "Allow SSH and HTTP access"

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

  ingress {
    description = "App Port"
    from_port   = 8081
    to_port     = 8081
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

resource "aws_instance" "nextread" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t3.micro"

  key_name = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.allow_web_ssh.id]

  tags = {
    Name = "NextReadServer"
  }
}

output "public_ip" {
  value = aws_instance.nextread.public_ip
}
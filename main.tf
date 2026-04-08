provider "aws" {
  region = "ap-south-1"
}

# 🔑 Create Key Pair (for SSH access)
resource "aws_key_pair" "deployer" {
  key_name   = "jenkins-key"
  public_key = file("jenkins-key.pub")
}

# 🔐 Security Group (allow SSH + HTTP)
resource "aws_security_group" "allow_web_ssh" {
  name        = "allow_web_ssh"
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

  # Optional (for testing/debug)
  ingress {
    description = "Custom App Port"
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

# 💻 EC2 Instance
resource "aws_instance" "nextread" {
  ami           = "ami-0f5ee92e2d63afc18"  # Ubuntu (Mumbai region)
  instance_type = "t2.micro"

  key_name = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.allow_web_ssh.id]

  tags = {
    Name = "NextReadServer"
  }
}

# 🌐 Output Public IP
output "public_ip" {
  value = aws_instance.nextread.public_ip
}
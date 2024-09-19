# AWS Provider
provider "aws" {
  region = var.aws_region
}

# Define a new security group
resource "aws_security_group" "medusa_sg" {
  name        = "medusa_sg1"
  description = "Allow HTTP and SSH"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (you can restrict this)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance for Medusa App
resource "aws_instance" "medusa_app" {
  ami           = "ami-0e86e20dae9224db8"  # Correct AMI ID
  instance_type = var.instance_type
  key_name      = var.key_name

  # Use the new security group created above
  vpc_security_group_ids = [aws_security_group.medusa_sg.id]

  # User data to set up Medusa
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nodejs npm
              sudo npm install -g @medusajs/medusa-cli pm2
              git clone https://github.com/medusajs/medusa-starter-default.git /home/ubuntu/medusa-app
              cd /home/ubuntu/medusa-app
              npm install
              pm2 start npm --name "medusa" -- run develop
              pm2 startup
              pm2 save
            EOF

  tags = {
    Name   = "MedusaAppInstance"
  }
}


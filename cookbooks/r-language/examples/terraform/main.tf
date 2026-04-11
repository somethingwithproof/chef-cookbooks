# Terraform example for deploying R Language Cookbook
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type for R server"
  type        = string
  default     = "t3.large"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "allowed_cidrs" {
  description = "CIDR blocks allowed to access SSH/RStudio/Shiny"
  type        = list(string)
  default     = []
}

variable "r_packages" {
  description = "R packages to install"
  type        = list(string)
  default     = ["dplyr", "ggplot2", "shiny", "rmarkdown"]
}

# Data sources
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group
resource "aws_security_group" "r_server" {
  name_prefix = "r-server-${var.environment}-"
  description = "Security group for R Analytics Server"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    description = "RStudio Server"
    from_port   = 8787
    to_port     = 8787
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    description = "Shiny Server"
    from_port   = 3838
    to_port     = 3838
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "r-server-sg-${var.environment}"
    Environment = var.environment
  }
}

# IAM Role for Chef Client
resource "aws_iam_role" "chef_client" {
  name = "chef-client-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_instance_profile" "chef_client" {
  name = "chef-client-profile-${var.environment}"
  role = aws_iam_role.chef_client.name
}

# User Data Script
locals {
  user_data = templatefile("${path.module}/bootstrap.sh", {
    environment  = var.environment
    r_packages   = jsonencode(var.r_packages)
    chef_version = "18.7.10"
  })
}

# EC2 Instance
resource "aws_instance" "r_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  security_groups        = [aws_security_group.r_server.name]
  iam_instance_profile   = aws_iam_instance_profile.chef_client.name
  user_data              = local.user_data
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 50
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name        = "r-analytics-server-${var.environment}"
    Environment = var.environment
    Purpose     = "R Analytics Platform"
    ChefManaged = "true"
  }
}

# Outputs
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.r_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.r_server.public_ip
}

output "rstudio_url" {
  description = "RStudio Server URL"
  value       = "http://${aws_instance.r_server.public_ip}:8787"
}

output "shiny_url" {
  description = "Shiny Server URL"
  value       = "http://${aws_instance.r_server.public_ip}:3838"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i your-key.pem ubuntu@${aws_instance.r_server.public_ip}"
}

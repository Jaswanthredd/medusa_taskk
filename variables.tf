variable "aws_region" {
  description = "AWS region where the instance will be launched"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t2.small"
}

variable "key_name" {
  description = "Name of the SSH key pair"
}


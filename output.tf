output "instance_ip" {
  description = "Public IP of the Medusa EC2 instance"
  value       = aws_instance.medusa_app.public_ip
}


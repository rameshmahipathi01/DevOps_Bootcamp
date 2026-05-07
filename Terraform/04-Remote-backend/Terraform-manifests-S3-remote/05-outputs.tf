output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.ramesh_ec2_instance.id
}

output "ec2_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.ramesh_ec2_instance.public_ip
}

output "ec2_private_ip" {
  description = "EC2 Private IP"
  value       = aws_instance.ramesh_ec2_instance.private_ip
}

output "ec2_availability_zone" {
  description = "Availability Zone"
  value       = aws_instance.ramesh_ec2_instance.availability_zone
}

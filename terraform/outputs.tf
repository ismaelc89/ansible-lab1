output "public_ip_ec2" {
  value = aws_instance.ansible_instance.public_ip
}

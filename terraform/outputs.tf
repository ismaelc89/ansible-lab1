output "public_ip_ec2" {
  value = aws_instance.ansible_instance.public_ip
}

output "supported_t3_micro_azs" {
  description = "AZs in this region that support t3.micro"
  value       = data.aws_ec2_instance_type_offerings.t3_micro.locations
}

output "selected_t3_micro_azs" {
  description = "Selected AZs in this region that support t3.micro"
  value       = data.aws_ec2_instance_type_offerings.t3_micro.locations[0]
}

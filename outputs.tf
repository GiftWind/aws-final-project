output "bastion-ip" {
description = "Bastion IP address"
  value = aws_instance.bastion.public_ip
}

output "private-instance-ip" {
  description = "Private instance IP address"
  value = aws_instance.private_instance_vpc_two.private_ip
}

output "private-instance-two-ip" {
  description = "Private instance two IP address"
  value = aws_instance.private_instance_vpc_two_2.private_ip
}

output "lb-dns-name" {
  description = "Domain name of ELB"
  value = aws_lb.load_balancer.dns_name
}

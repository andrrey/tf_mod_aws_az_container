output "private_subnet" {
  value = aws_subnet.private_subnet
}

output "public_subnet" {
  value = aws_subnet.public_subnet
}

output "inet_gw" {
  value = aws_internet_gateway.ig
}
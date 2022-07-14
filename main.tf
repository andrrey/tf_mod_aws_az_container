terraform {
  required_version = ">= 1.0.11"
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.private_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.name_prefix}-${var.availability_zone}-private-subn"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.public_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.name_prefix}-${var.availability_zone}-public-subn"
  }
}

resource "aws_internet_gateway" "ig" {
  count = var.inet_gw == "" ? 1 : 0
  vpc_id = var.vpc_id
  tags = {
    "Name" = "${var.name_prefix}-internet-gw"
  }
}

resource "aws_route_table" "rt4ig" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.inet_gw == "" ? aws_internet_gateway.ig[0].id : var.inet_gw[0].id
  }

  tags = {
    Name = "${var.name_prefix}-${var.availability_zone}-rt4ig"
  }
}

resource "aws_route_table_association" "rt_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt4ig.id
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    "Name" = "${var.name_prefix}-nat-gw"
  }

  depends_on = [
    aws_internet_gateway.ig
  ]
}

output "nat_gateway_ip" {
  value = aws_eip.nat_eip.public_ip
}

resource "aws_route_table" "rt4nat" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.name_prefix}-${var.availability_zone}-rt4nat"
  }
}

resource "aws_route_table_association" "instance" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.rt4nat.id
}
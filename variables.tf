variable "vpc_id" {
  description = "VPC ID"
}

variable "private_cidr_block" {
  description = "CIDR block for private subnetwork"
}

variable "public_cidr_block" {
  description = "CIDR block for public subnetwork"
}

variable "availability_zone" {
  description = "Availability Zone"
}

variable "name_prefix" {
  description = "Name prefix for naming seubnetworks"
}

variable "inet_gw" {
  description = "Internet gateway object. If empty, then it will be created"
  default = ""
}
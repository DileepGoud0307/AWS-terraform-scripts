variable "vpc_id" {
  description = "VPC ID where the resources will be created"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Private Subnet ID"
  type        = string
}

variable "public_route_table_id" {
  description = "Route Table ID for Public Subnet"
  type        = string
}

variable "private_route_table_id" {
  description = "Route Table ID for Private Subnet"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
}
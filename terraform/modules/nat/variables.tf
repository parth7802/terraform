variable "public_subnet_id" {
  type        = string
  description = "ID of the public subnet to launch the NAT Gateway in"
}

variable "private_subnet_ids" {
  type        = map(string)
  description = "List of private subnet IDs to associate with private route table"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where NAT Gateway and routes will be created"
}

variable "igw_dependency" {
  type        = any
  description = "Dependency on Internet Gateway to avoid race conditions"
}

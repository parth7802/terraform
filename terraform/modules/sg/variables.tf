variable "vpc_id" {
  type        = string
  description = "The VPC ID to associate with the security group"
}

variable "sg_name" {
  type        = string
  description = "Name of the security group"
  default     = "web-sg"
}

variable "http_ingress_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed for HTTP access"
  default     = ["0.0.0.0/0"]
}

variable "ssh_ingress_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed for SSH access"
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the security group"
  default     = {
    Name = "web-sg"
  }
}

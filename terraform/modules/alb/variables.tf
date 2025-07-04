variable "alb_name" {
  type        = string
  description = "Name of the ALB"
}

variable "is_internal" {
  type        = bool
  description = "Whether the ALB is internal"
}

variable "alb_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs for the ALB"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the ALB"
}

variable "target_group_name" {
  type        = string
  description = "Name of the Target Group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the Target Group"
}

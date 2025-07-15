variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "log_group_name" {
  type        = string
  description = "Name of the CloudWatch Log Group"
}

variable "log_group_retention" {
  type        = number
  description = "Retention period for logs"
  default     = 7
}

variable "container_name" {
  type        = string
  description = "Name of the container"
}

variable "container_image" {
  type        = string
  description = "Container image to use"
}

variable "container_cpu" {
  type        = number
  description = "CPU units for the container"
}

variable "container_memory" {
  type        = number
  description = "Memory in MB for the container"
}

variable "task_cpu" {
  type        = string
  description = "CPU units for the task definition"
}

variable "task_memory" {
  type        = string
  description = "Memory in MB for the task definition"
}

variable "execution_role_arn" {
  type        = string
  description = "IAM role ARN for ECS task execution"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for ECS service"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs for ECS service"
}

variable "target_group_arn" {
  type        = string
  description = "Target group ARN for ECS service"
}

variable "listener_dependency" {
  type        = any
  description = "ALB Listener dependency to avoid race condition"
}

variable "region" {
  type        = string
  description = "AWS region for CloudWatch Logs"
}

variable "container_port" {
  type        = number
  description = "Port the container listens on"
  default     = 80
}
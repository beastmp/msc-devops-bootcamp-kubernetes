variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace for resources"
  type        = string
  default     = "default"
}

variable "dynamodb_tables" {
  description = "DynamoDB table names"
  type = object({
    products = string
    orders   = string
    tickets  = string
  })
}

variable "service_name" {
  description = "Service name for resource naming and labels"
  type        = string
  default     = "cloudmart"
}

variable "component_role" {
  description = "Component role for resource naming and labels"
  type        = string
  default     = "main"
}


variable "environment" {
  description = "Environment name (dev, test, prod) for resource naming and labels"
  type        = string
  default     = "dev"
}

variable "org_name" {
  description = "Organization name for resource naming"
  type        = string
  default     = "beastmpdevelopment"
}

variable "team_id" {
  description = "Team identifier for resource naming"
  type        = string
  default     = "devops-bootcamp"
}

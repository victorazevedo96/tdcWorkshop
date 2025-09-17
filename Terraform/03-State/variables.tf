variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = "state-rg"
}

variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "eastus"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

locals {
  common_tags = {
    Environment = var.environment
    Project     = "Workshop"
    ManagedBy   = "Terraform"
  }

  prefix = "${var.resource_group_name}-${local.common_tags.Project}"
}

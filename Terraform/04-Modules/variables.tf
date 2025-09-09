variable "project" {
  type        = string
}

variable "location" {
  type        = string
  description = "Azure region for resources"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "address_space" {
  type        = string
  description = "Address space for the virtual network"
}

# Local variables
locals {
  common_tags = {
    Environment = var.environment
    Project     = "Workshop"
    ManagedBy   = "Terraform"
  }
  
  prefix = "${var.environment}-${var.project}"
}

variable "project" {
  type        = string
  default     = "workshop"
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

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "address_space" {
  type        = string
  description = "Address space for the virtual network"
  default     = "10.0.0.0/16"
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

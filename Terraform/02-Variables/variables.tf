# Input Variables
variable "project" {
  type        =  string
  description = "Name of the resource group"
  default     = "workshop"
}

variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "eastus2"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

# Local variables
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  }
  suffix = "rg"
  name = "${var.environment}-${var.project}-${local.suffix}"
}

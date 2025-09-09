# Input Variables
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

variable "address_space" {
  type = string
  description = "Address space for the virtual network"
}

variable "acr_rg_name" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "admin_username" {
  type        = string
  description = "Admin username for the virtual machine"
  default     = "adminuser"
}

variable "domain_name_label" {
  type        = string
  description = "Domain name label for the public IP"
  default     = "tdc-workshop-app0910"
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

variable "subscriptionId" {
  type        = string
  description = "Variable for our resource group"
  sensitive   = true
}

variable "ProjectPrefix" {
  type        = string
  description = "Resources will be marked with a sufix, Ex: ProjectPrefix-rg"
}

variable "usedBy" {
  type        = string
  description = "Area of the company that consumes the application"
}

variable "devTeam" {
  type        = string
  description = "Team in charge of development"
}

variable "location" {
  type        = string
  description = "location of all resources"
  default     = "eastus"
}

variable "environment" {
  type        = string
  description = "used to assign tag 'Environment' value"
}

variable "netFwVersion" {
  type        = string
  description = "Used by Windows App Service"
}
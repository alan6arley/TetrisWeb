terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  subscription_id = var.subscriptionId
  features {}
}

locals {
  projectName = var.ProjectPrefix
  environment = var.environment
  usedBy      = var.usedBy
  devTeam     = var.devTeam
  location    = var.location
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.projectName}-Rg"
  location = local.location
  tags = {
    "Environment" = local.environment
    "UsedBy"      = local.usedBy
    "DevTeam"     = local.devTeam
  }
}

resource "azurerm_app_service_plan" "asp" {
  name                = "${local.projectName}-Asp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_application_insights" "appins" {
  name                = "${local.projectName}-Insights"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_type    = "web"
}

resource "azurerm_app_service" "aslnx" {
  name                = "${local.projectName}-rog"
  resource_group_name = azurerm_app_service_plan.asp.resource_group_name
  location            = azurerm_app_service_plan.asp.location
  app_service_plan_id = azurerm_app_service_plan.asp.id
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.appins.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.appins.connection_string
  }
  
  site_config {
    websockets_enabled       = true
    linux_fx_version         = "NODE|14-lts"
    app_command_line         = "pm2 serve /home/site/wwwroot --no-daemon"
    always_on                = true
    dotnet_framework_version = var.netFwVersion
    remote_debugging_enabled = true
    remote_debugging_version = "VS2019"
  }
}
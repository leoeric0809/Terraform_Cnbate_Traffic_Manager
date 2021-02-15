terraform {
  required_version = ">= 0.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.47.0"
    }
  }
    backend "azurerm" {
    storage_account_name = "cnbateterraformstorage" 
    container_name       = "terraform-state" 
    key                  = "cnbate.terraform.stats"
  }
}

provider "azurerm" {
  features {}
}

locals {
  location_eastAsia      = "East Asia"
  location_southeastAsia = "Southeast Asia"
}


module "cnbate_traffic_manager" {
  source                 = "../module/traffic_manager_profile"
  traffic_manager_name   = var.traffic_manager_name
  resource_group_name    = var.resource_group_name
  traffic_routing_method = var.traffic_routing_method
  relative_name          = var.relative_name
  ttl                    = var.ttl
  tags                   = var.tags

  enable_traffic_manager_endpoint = var.enable_traffic_manager_endpoint
  traffic_manager_endpoint_count  = var.traffic_manager_endpoint_count
  traffic_manager_endpoint_names  = var.traffic_manager_endpoint_names
  target_resource_ids             = module.cnbate_Web_app.azurerm_app_service_ids
  traffic_manager_endpoint_type   = var.traffic_manager_endpoint_type
  geo_mappings                    = var.geo_mappings
}

module "cnbate_Web_app" {
  source                = "../module/web_app"
  app_service_locations = [local.location_eastAsia, local.location_southeastAsia]
  resource_group_name   = var.resource_group_name

  enable                  = var.enable
  enable_app_service_plan = var.enable_app_service_plan
  app_service_plan_count  = var.app_service_plan_count
  app_service_plan_names  = var.app_service_plan_names
  app_service_plans       = var.app_service_plans

  enable_app_service = var.enable_app_service
  app_service_count  = var.app_service_count
  app_service_names  = var.app_service_names
  app_settings       = var.app_settings
}

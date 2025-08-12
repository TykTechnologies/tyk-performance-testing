provider "azurerm" {
  version = "3.116.0"
  features {}
}

module "h" {
  source = "../modules/helpers"

  services_nodes_count      = var.services_nodes_count
  upstream_nodes_count      = var.upstream_nodes_count
  tests_nodes_count         = var.tests_nodes_count
  resource_nodes_count      = var.resource_nodes_count
  dependencies_nodes_count  = var.dependencies_nodes_count
  cluster_machine_type      = var.cluster_machine_type
  service_machine_type      = var.service_machine_type
  upstream_machine_type     = var.upstream_machine_type
  tests_machine_type        = var.tests_machine_type
  resources_machine_type    = var.resources_machine_type
  dependencies_machine_type = var.dependencies_machine_type

  tyk_enabled      = var.tyk_enabled
  kong_enabled     = var.kong_enabled
  gravitee_enabled = var.gravitee_enabled
  traefik_enabled  = var.traefik_enabled
  upstream_enabled = var.upstream_enabled
}

resource "azurerm_resource_group" "this" {
  name     = "pt-${var.cluster_location}"
  location = var.cluster_location
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  kubernetes_version  = var.aks_version
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = replace(azurerm_resource_group.this.name, "_", "-")

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each              = module.h.nodes
  name                  = substr(replace(each.key, "-", ""), 0, 12)
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id

  vm_size = module.h.machines[each.key]
  
  # Enable autoscaling for node pools
  enable_auto_scaling = true
  min_count = contains(["tyk", "kong", "gravitee", "traefik"], each.key) ? 2 : 1
  max_count = contains(["tyk", "kong", "gravitee", "traefik"], each.key) ? 6 : 3
  node_count = each.value  # Initial count

  node_labels = {
    "node": each.key
  }
}

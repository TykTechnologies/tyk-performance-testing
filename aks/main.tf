provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "pt-${var.cluster_machine_type}"
  location = var.cluster_location
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  kubernetes_version  = var.aks_version
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = replace(azurerm_resource_group.this.name, "_", "-")

  default_node_pool {
    name       = "this"
    node_count = 1
    vm_size    = var.cluster_machine_type
  }

  identity {
    type = "SystemAssigned"
  }
}

module "h" {
  source = "./modules"

  services_nodes_count      = var.services_nodes_count
  resource_nodes_count      = var.resource_nodes_count
  dependencies_nodes_count  = var.dependencies_nodes_count

  tyk_enabled      = var.tyk_enabled
  kong_enabled     = var.kong_enabled
  gravitee_enabled = var.gravitee_enabled
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each              = module.h.nodes
  name                  = substr(replace(each.key, "-", ""), 0, 12)
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id

  vm_size    = var.cluster_machine_type
  node_count = each.value

  node_labels = {
    "node": each.key
  }
}

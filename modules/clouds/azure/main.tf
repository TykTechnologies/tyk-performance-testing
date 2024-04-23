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
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each              = var.nodes
  name                  = substr(replace(each.key, "-", ""), 0, 12)
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id

  vm_size    = var.cluster_machine_type
  node_count = each.value

  node_labels = {
    "node": each.key
  }
}

resource "null_resource" "kube_config" {
  provisioner "local-exec" {
    command = <<EOT
      [[ $(kubectl config get-contexts performance-testing-aks | wc -l) -eq 2 ]] && kubectl config delete-context performance-testing-aks

      az aks get-credentials \
        --resource-group ${azurerm_resource_group.this.name} \
        --name ${azurerm_kubernetes_cluster.this.name}

      kubectl config rename-context $(kubectl config current-context) performance-testing-aks
    EOT
  }

  depends_on = [azurerm_kubernetes_cluster.this, azurerm_kubernetes_cluster_node_pool.this]
}

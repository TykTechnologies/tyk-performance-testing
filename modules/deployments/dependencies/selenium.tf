locals {
  selenium = {
    name = "selenium-hub"
    port = 4444
  }
}

resource "kubernetes_deployment" "selenium_hub" {
  metadata {
    name = local.selenium.name
    labels = {
      app = local.selenium.name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = local.selenium.name
      }
    }

    template {
      metadata {
        labels = {
          app = local.selenium.name
        }
      }

      spec {
        container {
          name  = local.selenium.name
          image = "selenium/hub"
          port {
            container_port = local.selenium.port
          }
          port {
            container_port = 4443
          }
          port {
            container_port = 4442
          }
          liveness_probe {
            http_get {
              path = "/wd/hub/status"
              port = local.selenium.port
            }
            initial_delay_seconds = 30
            timeout_seconds       = 5
          }
          readiness_probe {
            http_get {
              path = "/wd/hub/status"
              port = local.selenium.port
            }
            initial_delay_seconds = 30
            timeout_seconds       = 5
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "selenium_node_firefox" {
  metadata {
    name = "selenium-node-firefox"
    labels = {
      app = "selenium-node-firefox"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "selenium-node-firefox"
      }
    }

    template {
      metadata {
        labels = {
          app = "selenium-node-firefox"
        }
      }

      spec {
        volume {
          name = "dshm"
          empty_dir {
            medium = "Memory"
          }
        }

        container {
          name  = "selenium-node-firefox"
          image = "selenium/node-firefox"
          port {
            container_port = 5555
          }
          volume_mount {
            mount_path = "/dev/shm"
            name       = "dshm"
          }
          env {
            name  = "SE_EVENT_BUS_HOST"
            value = local.selenium.name
          }
          env {
            name  = "SE_EVENT_BUS_SUBSCRIBE_PORT"
            value = "4443"
          }
          env {
            name  = "SE_EVENT_BUS_PUBLISH_PORT"
            value = "4442"
          }
        }
      }
    }
  }

  depends_on = [kubernetes_deployment.selenium_hub]
}

resource "kubernetes_service" "selenium_hub" {
  metadata {
    name = local.selenium.name
    labels = {
      app = local.selenium.name
    }
  }

  spec {
    selector = {
      app = local.selenium.name
    }

    type = "NodePort"

    session_affinity = "None"

    port {
      port        = local.selenium.port
      target_port = local.selenium.port
      name        = "http"
    }

    port {
      port        = 4443
      target_port = 4443
      name        = "subscribe"
    }

    port {
      port        = 4442
      target_port = 4442
      name        = "publish"
    }
  }

  depends_on = [kubernetes_deployment.selenium_hub]
}

resource "kubernetes_config_map" "snapshot-script-configmap" {
  metadata {
    name = "snapshot-script-configmap"
    namespace = var.namespace
  }

  data = {
    "snapshot.py" = <<-EOF
      import os
      import logging
      from selenium import webdriver
      from selenium.webdriver.common.by import By
      from selenium.webdriver.support import expected_conditions
      from selenium.webdriver.support.ui import WebDriverWait

      logging.basicConfig()
      logging.getLogger().setLevel(logging.INFO)

      def is_element_present(by, selector):
          try:
              driver.find_element(by, selector)
              return True
          except:
              return False

      def safe_get_element(by, identifier):
          while not is_element_present(by, identifier):
              WebDriverWait(driver, 10).until(expected_conditions.presence_of_element_located((by, identifier)))
          return driver.find_element(by, identifier)

      options = webdriver.FirefoxOptions()
      options.add_argument("--headless")
      driver = webdriver.Remote(
        command_executor="http://${local.selenium.name}:${local.selenium.port}/wd/hub",
        options=options
      )

      logging.info("Requesting Grafana page.")
      driver.maximize_window()
      driver.get("http://${helm_release.grafana.name}")

      # Login
      login_form = safe_get_element(By.CLASS_NAME, "login-content-box").find_element(By.TAG_NAME, "form")
      login_form.find_element(By.NAME, "user").send_keys("${local.grafana.username}")
      login_form.find_element(By.NAME, "password").send_keys("${local.grafana.password}")
      login_form.submit()
      logging.info("Logged in successfully.")

      # Click menu button
      safe_get_element(By.ID, "mega-menu-toggle").click()

      # Click on dashboards
      safe_get_element(By.XPATH, '//a[@href="/dashboards"]').click()
      logging.info("Navigated to /dashboards.")

      # Select k6 dashboard
      safe_get_element(By.XPATH, "//*[text()='k6 Test Results']").click()
      logging.info("Navigated to k6 Test Results Dashboard.")

      # Click on Share button
      safe_get_element(By.XPATH, "//button[contains(., 'Share')]").click()
      logging.info("Clicked Share.")

      # Click on Snapshot
      safe_get_element(By.XPATH, "//button[contains(., 'Snapshot')]").click()
      logging.info("Selected Snapshot.")

      # Publish on Snapshot
      safe_get_element(By.XPATH, "//button[contains(., 'Publish to snapshots.raintank.io')]").click()
      logging.info("Generating raintank URL...")

      # Publish on Snapshot
      snapshot = safe_get_element(By.ID, "snapshot-url-input").get_attribute("value")

      print(snapshot)
      driver.quit()
    EOF
  }

  depends_on = [helm_release.grafana, kubernetes_deployment.selenium_hub]
}

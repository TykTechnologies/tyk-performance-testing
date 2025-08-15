locals {
  selenium = {
    name = "selenium-hub"
    port = 4444
  }
}

resource "kubernetes_deployment" "selenium_hub" {
  metadata {
    name      = local.selenium.name
    namespace = var.label
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
        node_selector = {
          node: var.label
        }

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

  depends_on = [kubernetes_namespace.dependencies]
}

resource "kubernetes_deployment" "selenium_node_firefox" {
  metadata {
    name      = "selenium-node-firefox"
    namespace = var.label
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
        node_selector = {
          node: var.label
        }

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

  depends_on = [kubernetes_namespace.dependencies]
}

resource "kubernetes_service" "selenium_hub" {
  metadata {
    name      = local.selenium.name
    namespace = var.label
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

  depends_on = [kubernetes_namespace.dependencies]
}

resource "kubernetes_config_map" "snapshot-script-configmap" {
  metadata {
    name      = "snapshot-script-configmap"
    namespace = var.namespace
  }

  data = {
    "snapshot.py" = <<-EOF
      import os
      import time
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

      TEST_DURATION = os.environ.get('TEST_DURATION')

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

      # Adjust timeframe
      safe_get_element(By.XPATH, "//button[contains(., 'Last 30 minutes')]").click()
      from_timeframe = safe_get_element(By.XPATH, "//input[@value='now-30m']")
      from_timeframe.clear()
      from_timeframe.send_keys(f'now-{TEST_DURATION}m')
      safe_get_element(By.XPATH, "//button[contains(., 'Apply time range')]").click()

      # Wait for dashboard to fully load data
      logging.info("Waiting for dashboard data to load...")
      time.sleep(30)  # Initial wait for queries to execute
      
      # Check if any panels have data by looking for "No data" indicators
      max_retries = 6
      retry_count = 0
      while retry_count < max_retries:
          no_data_elements = driver.find_elements(By.XPATH, "//*[contains(text(), 'No data')]")
          if len(no_data_elements) == 0:
              logging.info(f"Data loaded successfully after {retry_count * 10} seconds")
              break
          logging.info(f"Retry {retry_count + 1}/{max_retries}: Waiting for data to load...")
          time.sleep(10)
          # Refresh the page to trigger data reload
          driver.refresh()
          time.sleep(5)
          retry_count += 1

      # Scroll to the bottom to load entire dashboard
      scroll_body = safe_get_element(By.CLASS_NAME, "scrollbar-view")
      scroll_height = scroll_body.get_property("scrollHeight")
      scroll_top = 0
      while scroll_top < scroll_height:
          # Scroll down by a small increment
          driver.execute_script("arguments[0].scrollTop = arguments[1];", scroll_body, scroll_top)
          # Wait for a short time to simulate scrolling
          time.sleep(0.2)  # Increased scroll delay
          # Update the current scroll position
          scroll_top += 20  # Larger scroll increments

      # Force refresh dashboard one final time to ensure all data is loaded
      logging.info("Final dashboard refresh before snapshot...")
      driver.refresh()
      time.sleep(10)
      
      # Scroll back to top for clean snapshot
      driver.execute_script("arguments[0].scrollTop = 0;", scroll_body)
      time.sleep(2)

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

  depends_on = [kubernetes_namespace.dependencies]
}

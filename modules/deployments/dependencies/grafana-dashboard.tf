resource "kubernetes_config_map" "grafana-dashboard" {
  metadata {
    name      = "grafana-dashboards-configmap"
    namespace = var.namespace
  }

  depends_on = [kubernetes_namespace.dependencies]
  data = {
    "dashboards.json" = <<EOF
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "datasource",
          "uid": "grafana"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "target": {
          "limit": 100,
          "matchAny": false,
          "tags": [],
          "type": "dashboard"
        },
        "type": "dashboard"
      }
    ]
  },
  "description": "k6 Test Result",
  "editable": true,
  "fiscalYearStartMonth": 0,
  "gnetId": 18030,
  "graphTooltip": 1,
  "links": [],
  "liveNow": true,
  "panels": [
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 229,
      "panels": [],
      "title": "Test Information",
      "type": "row"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 0,
        "y": 1
      },
      "id": 51,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by(scenario) (k6_http_reqs_total{group!=\"::setup\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "K6 Test Executor",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 3,
        "y": 1
      },
      "id": 161,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "uniqueValues"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by(method) (k6_http_reqs_total{group!=\"::setup\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "K6 HTTP Request Type(s)",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "fieldMinMax": false,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "vus"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 6,
        "y": 1
      },
      "id": 157,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg (k6_test_config_virtual_users)",
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "K6 Test Virtual Users",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 9,
        "y": 1
      },
      "id": 163,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "uniqueValues"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by(state) (k6_deployment_config_analytics)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Analytics",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 12,
        "y": 1
      },
      "id": 166,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "uniqueValues"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by(state) (k6_deployment_config_auth)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Auth (Type/Key Count)",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 15,
        "y": 1
      },
      "id": 175,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "uniqueValues"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by(state) (k6_deployment_config_open_telemetry)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Open Telemetry",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 18,
        "y": 1
      },
      "id": 299,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "uniqueValues"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by(state) (k6_tests_fortio_options)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Fortio Response Parameters",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "Routes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 21,
        "y": 1
      },
      "id": 300,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg (k6_service_route_count)",
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "API Routes",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "m"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 0,
        "y": 6
      },
      "id": 156,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg (k6_test_config_duration)",
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "K6 Test Duration",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 3,
        "y": 6
      },
      "id": 160,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg (k6_test_config_rate)",
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "K6 Test Rate",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "fieldMinMax": false,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 6,
        "y": 6
      },
      "id": 196,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum by (instance_id) (k6_http_reqs_total{group!=\"::setup\"})",
          "format": "time_series",
          "fullMetaSearch": false,
          "hide": false,
          "includeNullMetadata": true,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        }
      ],
      "title": "K6 Test Pods",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 9,
        "y": 6
      },
      "id": 172,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "uniqueValues"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by(state) (k6_deployment_config_rate_limit)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Rate Limit (Rate/Seconds)",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 12,
        "y": 6
      },
      "id": 168,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "uniqueValues"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by(state) (k6_deployment_config_quota)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Quota (Rate/Seconds)",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "m"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 15,
        "y": 6
      },
      "id": 167,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "uniqueValues"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by(state) (k6_deployment_config_header_injection)",
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Header Injection",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "Apps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 18,
        "y": 6
      },
      "id": 301,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg (k6_service_app_count)",
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "API Apps",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "Hosts"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 3,
        "x": 21,
        "y": 6
      },
      "id": 302,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg (k6_service_host_count)",
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Fortio Hosts",
      "type": "stat"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 11
      },
      "id": 152,
      "panels": [],
      "title": "Overview",
      "type": "row"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 12,
        "w": 3,
        "x": 0,
        "y": 12
      },
      "id": 158,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "mean"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum by(testid) (rate(k6_http_reqs_total{group!=\"::setup\"}[30s]))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "RPS",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": true,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisGridShow": true,
            "axisLabel": "RPS",
            "axisPlacement": "left",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineStyle": {
              "fill": "solid"
            },
            "lineWidth": 1,
            "pointSize": 1,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "fieldMinMax": false,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "RPS"
            },
            "properties": [
              {
                "id": "custom.lineWidth",
                "value": 2
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "Errors"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "dark-red",
                  "mode": "fixed"
                }
              },
              {
                "id": "custom.lineWidth",
                "value": 5
              },
              {
                "id": "custom.lineStyle",
                "value": {
                  "fill": "solid"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 12,
        "w": 9,
        "x": 3,
        "y": 12
      },
      "id": 298,
      "interval": "5",
      "options": {
        "legend": {
          "calcs": [
            "min",
            "mean",
            "max",
            "lastNotNull"
          ],
          "displayMode": "table",
          "placement": "bottom",
          "showLegend": true
        },
        "timezones": [
          "browser"
        ],
        "tooltip": {
          "mode": "multi",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum by(testid) (rate(k6_http_reqs_total{group!=\"::setup\"}[30s]))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "Requests Rate   - {{testid}}",
          "range": true,
          "refId": "RPS"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by(testid) (sum by(testid) (rate(k6_http_reqs_total{group!=\"::setup\", expected_response=\"false\"}[30s])))",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "Failed Requests Rate  - {{testid}}",
          "range": true,
          "refId": "Errors"
        }
      ],
      "title": "RPS and Errors",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": true,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisGridShow": true,
            "axisLabel": "RPS",
            "axisPlacement": "left",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineStyle": {
              "fill": "solid"
            },
            "lineWidth": 1,
            "pointSize": 1,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          }
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "p99"
            },
            "properties": [
              {
                "id": "unit",
                "value": "s"
              },
              {
                "id": "custom.axisPlacement",
                "value": "right"
              },
              {
                "id": "custom.lineStyle",
                "value": {
                  "fill": "solid"
                }
              },
              {
                "id": "custom.lineWidth",
                "value": 2
              },
              {
                "id": "custom.axisLabel",
                "value": "Duration"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "p75"
            },
            "properties": [
              {
                "id": "unit",
                "value": "s"
              },
              {
                "id": "custom.lineStyle",
                "value": {
                  "dash": [
                    10,
                    10
                  ],
                  "fill": "dash"
                }
              },
              {
                "id": "custom.lineWidth",
                "value": 2
              },
              {
                "id": "custom.axisPlacement",
                "value": "right"
              },
              {
                "id": "custom.axisLabel",
                "value": "Duration"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 12,
        "w": 12,
        "x": 12,
        "y": 12
      },
      "id": 193,
      "interval": "5",
      "options": {
        "legend": {
          "calcs": [
            "min",
            "mean",
            "max",
            "lastNotNull"
          ],
          "displayMode": "table",
          "placement": "bottom",
          "showLegend": true
        },
        "timezones": [
          "browser"
        ],
        "tooltip": {
          "mode": "multi",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by(testid) (k6_http_req_duration_p99{group!=\"::setup\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "p99  - {{testid}}",
          "range": true,
          "refId": "p99"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "avg by(testid) (k6_http_req_duration_p75{group!=\"::setup\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "p75  - {{testid}}",
          "range": true,
          "refId": "p75"
        }
      ],
      "title": "Duration",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "short"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 8,
        "w": 3,
        "x": 0,
        "y": 24
      },
      "id": 49,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum by (testid) (k6_http_reqs_total{group!=\"::setup\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Requests Made",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": null
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 8,
        "w": 3,
        "x": 3,
        "y": 24
      },
      "id": 71,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "(sum by(testid) (k6_http_reqs_total{group!=\"::setup\",status=~\"2..\"}) * 100 / sum by(testid) (k6_http_reqs_total{group!=\"::setup\"}))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "HTTP 200s",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": null
              }
            ]
          },
          "unit": "none"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 8,
        "w": 3,
        "x": 6,
        "y": 24
      },
      "id": 282,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum by(testid) (k6_http_reqs_total{group!=\"::setup\",status=~\"4..\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "HTTP 400s",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "red",
                "value": null
              }
            ]
          },
          "unit": "none"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 8,
        "w": 3,
        "x": 9,
        "y": 24
      },
      "id": 283,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum by(testid) (k6_http_reqs_total{group!=\"::setup\",status=~\"5..\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "HTTP 500s",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8537fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "s"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 8,
        "w": 3,
        "x": 12,
        "y": 24
      },
      "id": 122,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "mean"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by (testid) (k6_http_req_duration_p99{group!=\"::setup\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "P99 Duration Time",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "s"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 8,
        "w": 3,
        "x": 15,
        "y": 24
      },
      "id": 281,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "mean"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by (testid) (k6_http_req_duration_p95{group!=\"::setup\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "P95 Duration Time",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "s"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 8,
        "w": 3,
        "x": 18,
        "y": 24
      },
      "id": 52,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "mean"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by (testid) (k6_http_req_duration_p90{group!=\"::setup\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "P90 Duration Time",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "s"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 8,
        "w": 3,
        "x": 21,
        "y": 24
      },
      "id": 126,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "mean"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by (testid) (k6_http_req_duration_p75{group!=\"::setup\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "P75 Duration Time",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "mappings": [],
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "short"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 12,
        "w": 3,
        "x": 0,
        "y": 32
      },
      "id": 194,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "mean"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum by(testid) (k6_vus{group!=\"::setup\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Average VUs",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisGridShow": false,
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineStyle": {
              "fill": "solid"
            },
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          }
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 12,
        "w": 9,
        "x": 3,
        "y": 32
      },
      "id": 14,
      "interval": "5",
      "options": {
        "legend": {
          "calcs": [
            "min",
            "max",
            "mean"
          ],
          "displayMode": "table",
          "placement": "bottom",
          "showLegend": true
        },
        "timezones": [
          "browser"
        ],
        "tooltip": {
          "mode": "multi",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum by(testid) (k6_vus{group!=\"::setup\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "Requests Rate   - {{testid}}",
          "range": true,
          "refId": "B"
        }
      ],
      "title": "Number of VUs",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "fieldMinMax": false,
          "mappings": [],
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 3,
        "x": 12,
        "y": 32
      },
      "id": 64,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum by(testid) (k6_data_sent_total)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Data Sent",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 25,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "normal"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "binBps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 12,
        "w": 9,
        "x": 15,
        "y": 32
      },
      "id": 18,
      "interval": "5s",
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "multi",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": true,
          "expr": "avg by(testid)(sum by(testid)(irate(k6_data_received_total[5m])))",
          "interval": "",
          "legendFormat": "Received - {{testid}}",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": true,
          "expr": "avg by(testid)(sum by(testid)(irate(k6_data_sent_total[5m])))",
          "hide": false,
          "interval": "",
          "legendFormat": "Sent - {{testid}}",
          "range": true,
          "refId": "B"
        }
      ],
      "title": "Data flow",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 3,
        "x": 12,
        "y": 38
      },
      "id": 63,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum by(testid) (k6_data_received_total)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Data Received",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "max": 100,
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^dependencies.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 44
      },
      "id": 123,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "avg by (node) (100 - (irate(node_cpu_seconds_total{mode=\"idle\"}[5m]) * 100)) * on(node) group_left(label_node) kube_node_labels{label_node!=\"\"} ",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "{{label_node}}",
          "range": true,
          "refId": "A",
          "useBackend": false
        }
      ],
      "title": "CPU Utilization per Node",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "max": 100,
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^dependencies.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 44
      },
      "id": 125,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "(1 - avg by (node) ((avg_over_time(node_memory_MemFree_bytes[5m])) / avg_over_time(node_memory_MemTotal_bytes[5m]))* on(node) group_left(label_node) kube_node_labels{label_node!=\"\"} ) * 100",
          "format": "time_series",
          "instant": false,
          "interval": "",
          "legendFormat": "{{label_node}}",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Memory Utilization per Node",
      "type": "timeseries"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 55
      },
      "id": 127,
      "panels": [],
      "title": "Gateways Utilization",
      "type": "row"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "Cores",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "none"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 56
      },
      "id": 136,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"tyk\", namespace=\"tyk\"}[5m])) by (node) ",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong\", namespace=\"kong\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee\", namespace=\"gravitee\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"traefik\", namespace=\"traefik\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "CPU Utilization per Service",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 56
      },
      "id": 137,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(container_memory_working_set_bytes{node=\"tyk\", namespace=\"tyk\"}) by (node)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"kong\", namespace=\"kong\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee\", namespace=\"gravitee\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"traefik\", namespace=\"traefik\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Memory Utilization per Service",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "Cores",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "none"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 67
      },
      "id": 128,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"tyk\",namespace=\"tyk\"}[5m])) by (pod)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong\",namespace=\"kong\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee\",namespace=\"gravitee\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"traefik\",namespace=\"traefik\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "CPU Utilization per Service Pods",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 67
      },
      "id": 130,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(container_memory_working_set_bytes{node=\"tyk\", namespace=\"tyk\"}) by (pod)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"kong\", namespace=\"kong\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee\", namespace=\"gravitee\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"traefik\", namespace=\"traefik\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Memory Utilization per Service Pods",
      "type": "timeseries"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 78
      },
      "id": 192,
      "panels": [],
      "title": "Horizontal Scaling",
      "type": "row"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "Shows the number of nodes over time for each gateway type during scaling",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "Node Count",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "stepAfter",
            "lineWidth": 2,
            "pointSize": 8,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "always",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "decimals": 0,
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "short"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "blue",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 79
      },
      "id": 301,
      "options": {
        "legend": {
          "calcs": ["last"],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "multi",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count by (label_node_node) (kube_node_info * on(node) group_left(label_node_node) kube_node_labels{label_node_node=~\"tyk|kong|gravitee|traefik\"})",
          "instant": false,
          "legendFormat": "{{label_node_node}} nodes",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gateway Nodes Over Time",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "Cores",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 79
      },
      "id": 151,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "count(kube_pod_status_phase{namespace=\"tyk\",pod=~\"gateway-tyk-tyk-gateway-[0-9]+.*\",phase=\"Running\"})",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "Tyk",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count(kube_pod_status_phase{namespace=\"kong\",pod=~\"kong-gateway-[0-9]+.*\",phase=\"Running\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "Kong",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count(kube_pod_status_phase{namespace=\"gravitee\",pod=~\"gravitee-apim-gateway-[0-9]+.*\",phase=\"Running\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "Gravitee",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count(kube_pod_status_phase{namespace=\"traefik\",pod=~\"traefik-[0-9]+.*\",phase=\"Running\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "Traefik",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Gateway HPA",
      "type": "timeseries"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 90
      },
      "id": 135,
      "panels": [],
      "title": "Gateway Resources Utilization",
      "type": "row"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "none"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 91
      },
      "id": 138,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"tyk-resources\",namespace=\"tyk\"}[5m])) by (node)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong-resources\",namespace=\"kong\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee-resources\",namespace=\"gravitee\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"traefik-resources\",namespace=\"traefik\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "CPU Utilization per Resource",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 91
      },
      "id": 144,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(container_memory_working_set_bytes{node=\"tyk-resources\", namespace=\"tyk\"}) by (node)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"kong-resources\", namespace=\"kong\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee-resources\", namespace=\"gravitee\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"traefik-resources\", namespace=\"traefik\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Memory Utilization per Resource",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "none"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 102
      },
      "id": 131,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"tyk-resources\",namespace=\"tyk\"}[5m])) by (pod)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong-resources\",namespace=\"kong\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee-resources\",namespace=\"gravitee\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"traefik-resources\",namespace=\"traefik\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "CPU Utilization per Resource Pods",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 102
      },
      "id": 139,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(container_memory_working_set_bytes{node=\"tyk-resources\", namespace=\"tyk\"}) by (pod)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"kong-resources\", namespace=\"kong\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee-resources\", namespace=\"gravitee\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"traefik-resources\", namespace=\"traefik\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Memory Utilization per Resource Pods",
      "type": "timeseries"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 113
      },
      "id": 142,
      "panels": [],
      "title": "Upstream Utilization",
      "type": "row"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "none"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 114
      },
      "id": 143,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"tyk-upstream\",namespace=\"tyk-upstream\"}[5m])) by (node)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong-upstream\",namespace=\"kong-upstream\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee-upstream\",namespace=\"gravitee-upstream\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"traefik-upstream\",namespace=\"traefik-upstream\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"upstream\",namespace=\"upstream\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "E"
        }
      ],
      "title": "CPU Utilization per Resource",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 114
      },
      "id": 132,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(container_memory_working_set_bytes{node=\"tyk-upstream\", namespace=\"tyk-upstream\"}) by (node)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"kong-upstream\", namespace=\"kong-upstream\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee-upstream\", namespace=\"gravitee-upstream\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"traefik-upstream\", namespace=\"traefik-upstream\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"upstream\", namespace=\"upstream\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "E"
        }
      ],
      "title": "Memory Utilization per Resource",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 125
      },
      "id": 145,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"tyk-upstream\",namespace=\"tyk-upstream\"}[5m])) by (pod)",
          "format": "time_series",
          "fullMetaSearch": false,
          "hide": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong-upstream\",namespace=\"kong-upstream\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee-upstream\",namespace=\"gravitee-upstream\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"traefik-upstream\",namespace=\"traefik-upstream\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"upstream\",namespace=\"upstream\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "E"
        }
      ],
      "title": "CPU Utilization per Resource Pods",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 125
      },
      "id": 146,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(container_memory_working_set_bytes{node=\"tyk-upstream\", namespace=\"tyk-upstream\"}) by (pod)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"kong-upstream\", namespace=\"kong-upstream\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee-upstream\", namespace=\"gravitee-upstream\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"traefik-upstream\", namespace=\"traefik-upstream\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"upstream\", namespace=\"upstream\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "E"
        }
      ],
      "title": "Memory Utilization per Resource Pods",
      "type": "timeseries"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 136
      },
      "id": 141,
      "panels": [],
      "title": "Tests Utilization",
      "type": "row"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "none"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 137
      },
      "id": 147,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"tyk-tests\",namespace=\"tyk\"}[5m])) by (node)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong-tests\",namespace=\"kong\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee-tests\",namespace=\"gravitee\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"traefik-tests\",namespace=\"traefik\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"upstream-tests\",namespace=\"upstream\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "E"
        }
      ],
      "title": "CPU Utilization per Resource",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*tyk.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*kong.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*gravitee.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/.*traefik.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          },
          {
            "matcher": {
              "id": "byRegexp",
              "options": "/^upstream.*/"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Upstream"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 137
      },
      "id": 150,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(container_memory_working_set_bytes{node=\"tyk-tests\", namespace=\"tyk\"}) by (node)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"kong-tests\", namespace=\"kong\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee-tests\", namespace=\"gravitee\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"traefik-tests\", namespace=\"traefik\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"upstream-tests\", namespace=\"upstream\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "E"
        }
      ],
      "title": "Memory Utilization per Resource",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 148
      },
      "id": 148,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"tyk-tests\",namespace=\"tyk\"}[5m])) by (pod)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong-tests\",namespace=\"kong\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee-tests\",namespace=\"gravitee\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"traefik-tests\",namespace=\"traefik\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"upstream-tests\",namespace=\"upstream\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "E"
        }
      ],
      "title": "CPU Utilization per Resource Pods",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 148
      },
      "id": 149,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(container_memory_working_set_bytes{node=\"tyk-tests\", namespace=\"tyk\"}) by (pod)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"kong-tests\", namespace=\"kong\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee-tests\", namespace=\"gravitee\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"traefik-tests\", namespace=\"traefik\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(container_memory_working_set_bytes{node=\"upstream-tests\", namespace=\"upstream\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "E"
        }
      ],
      "title": "Memory Utilization per Resource Pods",
      "type": "timeseries"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 159
      },
      "id": 140,
      "panels": [],
      "title": "Dependencies Utilization",
      "type": "row"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "none"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 160
      },
      "id": 133,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"dependencies\",namespace=\"dependencies\"}[5m])) by (pod)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        }
      ],
      "title": "CPU Utilization per Dependencies Pods",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 100
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 160
      },
      "id": 134,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "disableTextWrap": false,
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(container_memory_working_set_bytes{node=\"dependencies\", namespace=\"dependencies\"}) by (pod)",
          "format": "time_series",
          "fullMetaSearch": false,
          "includeNullMetadata": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A",
          "useBackend": false
        }
      ],
      "title": "Memory Utilization per Dependencies Pods",
      "type": "timeseries"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 171
      },
      "id": 197,
      "panels": [],
      "title": "Machines Information",
      "type": "row"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#20edba",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "A"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "B"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "C"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "D"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 4,
        "x": 0,
        "y": 172
      },
      "id": 200,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "uniqueValues"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "count(kube_node_labels{label_node_node=\"tyk\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count(kube_node_labels{label_node_node=\"kong\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count(kube_node_labels{label_node_node=\"gravitee\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"traefik\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Gateways",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#20edba",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "A"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "B"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "C"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "D"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 4,
        "x": 4,
        "y": 172
      },
      "id": 284,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "uniqueValues"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"tyk-resources\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"kong-resources\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"gravitee-resources\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"traefik-resources\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Gateways Resources",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 9,
        "w": 4,
        "x": 8,
        "y": 172
      },
      "id": 259,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "uniqueValues"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"dependencies\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Dependencies",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#20edba",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "A"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "B"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "C"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "D"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "E"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 6,
        "x": 12,
        "y": 172
      },
      "id": 285,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "uniqueValues"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"tyk-upstream\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"kong-upstream\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"gravitee-upstream\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"traefik-upstream\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"upstream\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "E"
        }
      ],
      "title": "Upstreams",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#20edba",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "A"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "B"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "C"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "D"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "E"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#8438fa",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 6,
        "x": 18,
        "y": 172
      },
      "id": 286,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "uniqueValues"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"tyk-tests\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"kong-tests\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"gravitee-tests\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"traefik-tests\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node_node=\"upstream-tests\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "E"
        }
      ],
      "title": "Tests",
      "type": "stat"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 181
      },
      "id": 230,
      "panels": [],
      "title": "Service Container Resources Requests & Limits",
      "type": "row"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#20edba",
                "value": null
              }
            ]
          },
          "unit": "cores"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "A"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "B"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "C"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "D"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 3,
        "x": 0,
        "y": 182
      },
      "id": 287,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by (container) (kube_pod_container_resource_requests{container=\"gateway-tyk-gateway\", resource=\"cpu\", namespace=\"tyk\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "avg by (container) (kube_pod_container_resource_requests{container=\"proxy\",resource=\"cpu\", namespace=\"kong\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "avg by (container) (kube_pod_container_resource_requests{container=\"gravitee-apim-gateway\",resource=\"cpu\", namespace=\"gravitee\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "avg by (container) (kube_pod_container_resource_requests{container=\"traefik\",resource=\"cpu\", namespace=\"traefik\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Containers CPU Requests",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#20edba",
                "value": null
              }
            ]
          },
          "unit": "cores"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "A"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "B"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "C"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "D"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 3,
        "x": 3,
        "y": 182
      },
      "id": 288,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by (container) (kube_pod_container_resource_limits{container=\"gateway-tyk-gateway\",resource=\"cpu\", namespace=\"tyk\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "avg by (container) (kube_pod_container_resource_limits{container=\"proxy\",resource=\"cpu\", namespace=\"kong\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "avg by (container) (kube_pod_container_resource_limits{container=\"gravitee-apim-gateway\",resource=\"cpu\", namespace=\"gravitee\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "avg by (container) (kube_pod_container_resource_limits{container=\"traefik\",resource=\"cpu\", namespace=\"traefik\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Containers CPU Limits",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#20edba",
                "value": null
              }
            ]
          },
          "unit": "cores"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "A"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "B"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "C"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "D"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 3,
        "x": 6,
        "y": 182
      },
      "id": 289,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum(kube_pod_container_resource_requests{container=\"gateway-tyk-gateway\", resource=\"cpu\", namespace=\"tyk\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(kube_pod_container_resource_requests{container=\"proxy\",resource=\"cpu\", namespace=\"kong\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(kube_pod_container_resource_requests{container=\"gravitee-apim-gateway\",resource=\"cpu\", namespace=\"gravitee\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(kube_pod_container_resource_requests{container=\"traefik\",resource=\"cpu\", namespace=\"traefik\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Total CPU Requests",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#20edba",
                "value": null
              }
            ]
          },
          "unit": "cores"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "A"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "B"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "C"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "D"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 3,
        "x": 9,
        "y": 182
      },
      "id": 290,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum(kube_pod_container_resource_limits{container=\"gateway-tyk-gateway\",resource=\"cpu\", namespace=\"tyk\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(kube_pod_container_resource_limits{container=\"proxy\",resource=\"cpu\", namespace=\"kong\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(kube_pod_container_resource_limits{container=\"gravitee-apim-gateway\",resource=\"cpu\", namespace=\"gravitee\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(kube_pod_container_resource_limits{container=\"traefik\",resource=\"cpu\", namespace=\"traefik\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Total CPU Limits",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "fieldMinMax": false,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#20edba",
                "value": null
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "A"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "B"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "C"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "D"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 3,
        "x": 12,
        "y": 182
      },
      "id": 291,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by (container) (kube_pod_container_resource_requests{container=\"gateway-tyk-gateway\",resource=\"memory\", namespace=\"tyk\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "avg by (container) (kube_pod_container_resource_requests{container=\"proxy\",resource=\"memory\", namespace=\"kong\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "avg by (container) (kube_pod_container_resource_requests{container=\"gravitee-apim-gateway\",resource=\"memory\", namespace=\"gravitee\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "avg by (container) (kube_pod_container_resource_requests{container=\"traefik\",resource=\"memory\", namespace=\"traefik\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Containers Memory Requests",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "fieldMinMax": false,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#20edba",
                "value": null
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "A"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "B"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "C"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "D"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 3,
        "x": 15,
        "y": 182
      },
      "id": 295,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by (container) (kube_pod_container_resource_limits{container=\"gateway-tyk-gateway\",resource=\"memory\", namespace=\"tyk\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "avg by (container) (kube_pod_container_resource_limits{container=\"proxy\",resource=\"memory\", namespace=\"kong\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "avg by (container) (kube_pod_container_resource_limits{container=\"gravitee-apim-gateway\",resource=\"memory\", namespace=\"gravitee\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "avg by (container) (kube_pod_container_resource_limits{container=\"traefik\",resource=\"memory\", namespace=\"traefik\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Containers Memory Limits",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#20edba",
                "value": null
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "A"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "B"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "C"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "D"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 3,
        "x": 18,
        "y": 182
      },
      "id": 296,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum(kube_pod_container_resource_requests{container=\"gateway-tyk-gateway\",resource=\"memory\", namespace=\"tyk\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(kube_pod_container_resource_requests{container=\"proxy\",resource=\"memory\", namespace=\"kong\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(kube_pod_container_resource_requests{container=\"gravitee-apim-gateway\",resource=\"memory\", namespace=\"gravitee\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(kube_pod_container_resource_requests{container=\"traefik\",resource=\"memory\", namespace=\"traefik\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Total Memory Requests",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "PBFA97CFB590B2093"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "#8438fa",
            "mode": "fixed"
          },
          "decimals": 2,
          "fieldMinMax": false,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#20edba",
                "value": null
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "A"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#20edba",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Tyk"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "B"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#1155cb",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Kong"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "C"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#fe733f",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Gravitee"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "D"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "#00b8d4",
                  "mode": "fixed"
                }
              },
              {
                "id": "displayName",
                "value": "Traefik"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 3,
        "x": 21,
        "y": 182
      },
      "id": 297,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "value_and_name",
        "wideLayout": true
      },
      "pluginVersion": "10.4.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "sum(kube_pod_container_resource_limits{container=\"gateway-tyk-gateway\",resource=\"memory\", namespace=\"tyk\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(kube_pod_container_resource_limits{container=\"proxy\",resource=\"memory\", namespace=\"kong\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(kube_pod_container_resource_limits{container=\"gravitee-apim-gateway\",resource=\"memory\", namespace=\"gravitee\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum(kube_pod_container_resource_limits{container=\"traefik\",resource=\"memory\", namespace=\"traefik\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Total Memory Limits",
      "type": "stat"
    }
  ],
  "refresh": "5s",
  "revision": 1,
  "schemaVersion": 39,
  "tags": [
    "prometheus",
    "k6"
  ],
  "templating": {
    "list": [
      {
        "datasource": {
          "type": "prometheus",
          "uid": "PBFA97CFB590B2093"
        },
        "filters": [],
        "hide": 0,
        "name": "Filters",
        "skipUrlSync": false,
        "type": "adhoc"
      }
    ]
  },
  "time": {
    "from": "now-30m",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "",
  "title": "k6 Test Results",
  "uid": "k6-test-results",
  "version": 1,
  "weekStart": ""
}
EOF
  }
}
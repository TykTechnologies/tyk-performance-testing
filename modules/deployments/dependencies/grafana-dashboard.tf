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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 4,
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 8,
        "y": 1
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
            "uniqueValues"
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
      "title": "K6 Test Duration (mins)",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 12,
        "y": 1
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
            "uniqueValues"
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
      "title": "K6 Test Rate (RPS)",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 16,
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
            "uniqueValues"
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 1
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 0,
        "y": 6
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 4,
        "y": 6
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
      "title": "Auth",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 8,
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
          "expr": "avg (k6_deployment_config_auth)",
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Auth Token Count",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 2,
        "x": 12,
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
      "title": "Rate Limit",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 2,
        "x": 14,
        "y": 6
      },
      "id": 174,
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
          "expr": "avg by(per) (k6_deployment_config_rate_limit)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Per (secs)",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 2,
        "x": 16,
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
      "title": "Quota",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 2,
        "x": 18,
        "y": 6
      },
      "id": 170,
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
          "expr": "avg by(per) (k6_deployment_config_quota)",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Per (secs)",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 6
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
            "fixedColor": "text",
            "mode": "palette-classic"
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
          }
        ]
      },
      "gridPos": {
        "h": 7,
        "w": 4,
        "x": 0,
        "y": 12
      },
      "id": 158,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "vertical",
        "reduceOptions": {
          "calcs": [
            "max"
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
          "expr": "sum by(testid) (rate(k6_http_reqs_total{group!=\"::setup\"}[$__rate_interval]))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Peak RPS",
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
            "fixedColor": "text",
            "mode": "palette-classic"
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
          }
        ]
      },
      "gridPos": {
        "h": 7,
        "w": 4,
        "x": 4,
        "y": 12
      },
      "id": 195,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "vertical",
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
          "expr": "avg (k6_test_config_duration)",
          "hide": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "name": "Expression",
            "type": "__expr__",
            "uid": "__expr__"
          },
          "expression": "A",
          "hide": true,
          "reducer": "mean",
          "refId": "C",
          "type": "reduce"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "sum by (testid) (k6_http_reqs_total{group!=\"::setup\"})",
          "hide": true,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "name": "Expression",
            "type": "__expr__",
            "uid": "__expr__"
          },
          "expression": "$B / ($C * 60)",
          "hide": false,
          "refId": "RPS",
          "type": "math"
        }
      ],
      "title": "Cumulative Average RPS per Test",
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
            "fixedColor": "text",
            "mode": "palette-classic"
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
          }
        ]
      },
      "gridPos": {
        "h": 7,
        "w": 4,
        "x": 8,
        "y": 12
      },
      "id": 122,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "vertical",
        "reduceOptions": {
          "calcs": [
            "max"
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
            "fixedColor": "text",
            "mode": "palette-classic"
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
          }
        ]
      },
      "gridPos": {
        "h": 7,
        "w": 4,
        "x": 12,
        "y": 12
      },
      "id": 52,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "vertical",
        "reduceOptions": {
          "calcs": [
            "max"
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
            "fixedColor": "text",
            "mode": "palette-classic"
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
          }
        ]
      },
      "gridPos": {
        "h": 7,
        "w": 4,
        "x": 16,
        "y": 12
      },
      "id": 126,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "vertical",
        "reduceOptions": {
          "calcs": [
            "max"
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
            "fixedColor": "red",
            "mode": "palette-classic"
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
          "unit": "reqs"
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
          }
        ]
      },
      "gridPos": {
        "h": 7,
        "w": 4,
        "x": 20,
        "y": 12
      },
      "id": 71,
      "interval": "1s",
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "vertical",
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
          "expr": "sum by(testid) (k6_http_reqs_total{group!=\"::setup\", expected_response=\"false\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}} -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "HTTP Failures",
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
            "lineInterpolation": "linear",
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
              "id": "byName",
              "options": "Response  Time (avg)  - "
            },
            "properties": [
              {
                "id": "displayName",
                "value": "Response Time (avg) - without testid"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "A"
            },
            "properties": [
              {
                "id": "custom.axisPlacement",
                "value": "left"
              },
              {
                "id": "color",
                "value": {
                  "mode": "fixed"
                }
              },
              {
                "id": "custom.axisLabel",
                "value": "VUs"
              },
              {
                "id": "custom.scaleDistribution",
                "value": {
                  "log": 10,
                  "type": "log"
                }
              },
              {
                "id": "custom.showPoints",
                "value": "never"
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
                "id": "color",
                "value": {
                  "fixedColor": "orange",
                  "mode": "fixed"
                }
              },
              {
                "id": "custom.axisLabel",
                "value": "RPS"
              },
              {
                "id": "custom.lineWidth",
                "value": 3
              },
              {
                "id": "custom.lineInterpolation",
                "value": "smooth"
              },
              {
                "id": "decimals",
                "value": 0
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
                  "fixedColor": "red",
                  "mode": "fixed"
                }
              },
              {
                "id": "custom.lineWidth",
                "value": 5
              },
              {
                "id": "custom.lineInterpolation",
                "value": "smooth"
              },
              {
                "id": "custom.axisPlacement",
                "value": "hidden"
              },
              {
                "id": "decimals",
                "value": 0
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
                "id": "custom.axisPlacement",
                "value": "right"
              },
              {
                "id": "color",
                "value": {
                  "fixedColor": "green",
                  "mode": "fixed"
                }
              },
              {
                "id": "unit",
                "value": "s"
              },
              {
                "id": "custom.fillOpacity",
                "value": 18
              },
              {
                "id": "custom.lineInterpolation",
                "value": "smooth"
              },
              {
                "id": "custom.axisLabel",
                "value": "Response Time"
              },
              {
                "id": "decimals",
                "value": 2
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Active VUs   - "
            },
            "properties": [
              {
                "id": "displayName",
                "value": "Active VUs - without testid"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Requests Rate   - "
            },
            "properties": [
              {
                "id": "displayName",
                "value": "Requests Rate - without testid"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Failed Requests Rate  - "
            },
            "properties": [
              {
                "id": "displayName",
                "value": "Failed Requests Rate - without testid"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 9,
        "x": 0,
        "y": 19
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
          "exemplar": true,
          "expr": "sum by(testid) (rate(k6_http_reqs_total{group!=\"::setup\"}[$__rate_interval]))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "Requests Rate   - {{testid}}",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "avg by(testid) (sum by(testid) (rate(k6_http_reqs_total{group!=\"::setup\", expected_response=\"false\"}[$__rate_interval])))",
          "hide": false,
          "instant": false,
          "legendFormat": "Failed Requests Rate  - {{testid}}",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Requests per Second",
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
            "fixedColor": "text",
            "mode": "palette-classic"
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 3,
        "x": 9,
        "y": 19
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 9,
        "x": 12,
        "y": 19
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
            "fixedColor": "text",
            "mode": "palette-classic"
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 3,
        "x": 21,
        "y": 19
      },
      "id": 194,
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
          "expr": "sum by(testid) (avg_over_time(k6_vus{group!=\"::setup\"}[$__rate_interval]))",
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 30
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 30
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 41
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
          "expr": "avg by(testid)(sum by(testid)(irate(k6_data_received_total[$__rate_interval])))",
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
          "expr": "avg by(testid)(sum by(testid)(irate(k6_data_sent_total[$__rate_interval])))",
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
            "fixedColor": "text",
            "mode": "palette-classic"
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
          "unit": "decbytes"
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 6,
        "x": 12,
        "y": 41
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
          "editorMode": "builder",
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
            "fixedColor": "text",
            "mode": "palette-classic"
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
          "unit": "decbytes"
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 6,
        "x": 18,
        "y": 41
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
          "editorMode": "builder",
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
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 52
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 53
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee\", namespace=\"gravitee\"}[5m])) by (node)",
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong\", namespace=\"kong\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 53
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
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee\", namespace=\"gravitee\"}) by (node)",
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
          "expr": "sum(container_memory_working_set_bytes{node=\"kong\", namespace=\"kong\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 64
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee\",namespace=\"gravitee\"}[5m])) by (pod)",
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong\",namespace=\"kong\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 64
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
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee\", namespace=\"gravitee\"}) by (pod)",
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
          "expr": "sum(container_memory_working_set_bytes{node=\"kong\", namespace=\"kong\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
        "y": 75
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
              "options": "/.*Tyk.*/"
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
              "options": "/.*Kong.*/"
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
              "options": "/.*Gravitee.*/"
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 76
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
          "expr": "count(kube_pod_status_phase{namespace=\"gravitee\",pod=~\"gravitee-apim-gateway-[0-9]+.*\",phase=\"Running\"})",
          "hide": false,
          "instant": false,
          "legendFormat": "Gravitee",
          "range": true,
          "refId": "B"
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
          "refId": "C"
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
        "y": 87
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 88
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee-resources\",namespace=\"gravitee\"}[5m])) by (node)",
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong-resources\",namespace=\"kong\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 88
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
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee-resources\", namespace=\"gravitee\"}) by (node)",
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
          "expr": "sum(container_memory_working_set_bytes{node=\"kong-resources\", namespace=\"kong\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
            "__systemRef": "hideSeriesFrom",
            "matcher": {
              "id": "byNames",
              "options": {
                "mode": "exclude",
                "names": [
                  "kong-controller-6bcfdcb986-5lgg2",
                  "graviteeio-apim-elasticsearch-master-1",
                  "kong-redis-replicas-1",
                  "kong-redis-replicas-2",
                  "gravitee-apim-portal-66759d6559-kg7zm",
                  "gravitee-apim-api-69b8fc9c45-jp855",
                  "tyk-redis-redis-cluster-5",
                  "graviteeio-apim-elasticsearch-coordinating-0",
                  "tyk-operator-controller-manager-795cb98dd7-629fd",
                  "dashboard-tyk-tyk-dashboard-7df9cc9746-v98lk",
                  "tyk-pgsql-postgresql-0",
                  "tyk-redis-redis-cluster-0",
                  "tyk-redis-redis-cluster-3",
                  "tyk-redis-redis-cluster-2",
                  "tyk-redis-redis-cluster-1",
                  "tyk-redis-redis-cluster-4"
                ],
                "prefix": "All except:",
                "readOnly": true
              }
            },
            "properties": [
              {
                "id": "custom.hideFrom",
                "value": {
                  "legend": false,
                  "tooltip": false,
                  "viz": true
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
        "y": 99
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee-resources\",namespace=\"gravitee\"}[5m])) by (pod)",
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong-resources\",namespace=\"kong\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 99
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
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee-resources\", namespace=\"gravitee\"}) by (pod)",
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
          "expr": "sum(container_memory_working_set_bytes{node=\"kong-resources\", namespace=\"kong\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
        "y": 110
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 111
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee-upstream\",namespace=\"gravitee-upstream\"}[5m])) by (node)",
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong-upstream\",namespace=\"kong-upstream\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 111
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
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee-upstream\", namespace=\"gravitee-upstream\"}) by (node)",
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
          "expr": "sum(container_memory_working_set_bytes{node=\"kong-upstream\", namespace=\"kong-upstream\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
        "y": 122
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee-upstream\",namespace=\"gravitee-upstream\"}[5m])) by (pod)",
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong-upstream\",namespace=\"kong-upstream\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
        "y": 122
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
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee-upstream\", namespace=\"gravitee-upstream\"}) by (pod)",
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
          "expr": "sum(container_memory_working_set_bytes{node=\"kong-upstream\", namespace=\"kong-upstream\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
        "y": 133
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 134
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee-tests\",namespace=\"gravitee\"}[5m])) by (node)",
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong-tests\",namespace=\"kong\"}[5m])) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 134
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
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee-tests\", namespace=\"gravitee\"}) by (node)",
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
          "expr": "sum(container_memory_working_set_bytes{node=\"kong-tests\", namespace=\"kong\"}) by (node)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
        "y": 145
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"gravitee-tests\",namespace=\"gravitee\"}[5m])) by (pod)",
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"kong-tests\",namespace=\"kong\"}[5m])) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
        "y": 145
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
          "expr": "sum(container_memory_working_set_bytes{node=\"gravitee-tests\", namespace=\"gravitee\"}) by (pod)",
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
          "expr": "sum(container_memory_working_set_bytes{node=\"kong-tests\", namespace=\"kong\"}) by (pod)",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
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
        "y": 156
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
        "y": 157
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
        "y": 157
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
        "y": 168
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
            "fixedColor": "#20edba",
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
        "h": 5,
        "w": 4,
        "x": 0,
        "y": 169
      },
      "id": 198,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"tyk\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Machine",
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
            "fixedColor": "#20edba",
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
        "h": 5,
        "w": 4,
        "x": 4,
        "y": 169
      },
      "id": 214,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"tyk\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Machine Count",
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
            "fixedColor": "#1155cb",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#1155cb",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 8,
        "y": 169
      },
      "id": 200,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"kong\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Machine",
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
            "fixedColor": "#1155cb",
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
        "h": 5,
        "w": 4,
        "x": 12,
        "y": 169
      },
      "id": 217,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"kong\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Machine Count",
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
            "fixedColor": "#fe733f",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#1155cb",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 16,
        "y": 169
      },
      "id": 220,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"gravitee\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Machine",
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
            "fixedColor": "#fe733f",
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
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 169
      },
      "id": 203,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"gravitee\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Machine Count",
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
            "fixedColor": "#20edba",
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
        "h": 5,
        "w": 4,
        "x": 0,
        "y": 174
      },
      "id": 213,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"tyk-resources\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Resources Machine",
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
            "fixedColor": "#20edba",
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
        "h": 5,
        "w": 4,
        "x": 4,
        "y": 174
      },
      "id": 215,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"tyk-resources\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Resources Machine Count",
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
            "fixedColor": "#1155cb",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#1155cb",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 8,
        "y": 174
      },
      "id": 208,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"kong-resources\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Resources Machine",
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
            "fixedColor": "#1155cb",
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
        "h": 5,
        "w": 4,
        "x": 12,
        "y": 174
      },
      "id": 218,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"kong-resources\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Resources Machine Count",
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
            "fixedColor": "#fe733f",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#1155cb",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 16,
        "y": 174
      },
      "id": 221,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"gravitee-resources\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Resources Machine",
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
            "fixedColor": "#fe733f",
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
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 174
      },
      "id": 225,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"gravitee-resources\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Resources Machine Count",
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
            "fixedColor": "#20edba",
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
        "h": 5,
        "w": 4,
        "x": 0,
        "y": 179
      },
      "id": 204,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"tyk-upstream\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Upstream Machine",
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
            "fixedColor": "#20edba",
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
        "h": 5,
        "w": 4,
        "x": 4,
        "y": 179
      },
      "id": 199,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"tyk-upstream\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Upstream Machine Count",
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
            "fixedColor": "#1155cb",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#1155cb",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 8,
        "y": 179
      },
      "id": 206,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"kong-upstream\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Upstream Machine",
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
            "fixedColor": "#1155cb",
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
        "h": 5,
        "w": 4,
        "x": 12,
        "y": 179
      },
      "id": 219,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"kong-upstream\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Upstream Machine Count",
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
            "fixedColor": "#fe733f",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#1155cb",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 16,
        "y": 179
      },
      "id": 202,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"gravitee-upstream\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Upstream Machine",
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
            "fixedColor": "#fe733f",
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
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 179
      },
      "id": 223,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"gravitee-upstream\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Upstream Machine Count",
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
            "fixedColor": "#20edba",
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
        "h": 5,
        "w": 4,
        "x": 0,
        "y": 184
      },
      "id": 212,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"tyk-tests\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Tests Machine",
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
            "fixedColor": "#20edba",
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
        "h": 5,
        "w": 4,
        "x": 4,
        "y": 184
      },
      "id": 216,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"tyk-tests\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Tests Machine Count",
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
            "fixedColor": "#1155cb",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#1155cb",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 8,
        "y": 184
      },
      "id": 207,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"kong-tests\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Tests Machine",
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
            "fixedColor": "#1155cb",
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
        "h": 5,
        "w": 4,
        "x": 12,
        "y": 184
      },
      "id": 201,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"kong-tests\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Tests Machine Count",
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
            "fixedColor": "#fe733f",
            "mode": "fixed"
          },
          "decimals": 2,
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "#1155cb",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 16,
        "y": 184
      },
      "id": 222,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"gravitee-tests\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Tests Machine",
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
            "fixedColor": "#fe733f",
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
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 184
      },
      "id": 224,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"gravitee-tests\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Tests Machine Count",
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
        "h": 5,
        "w": 12,
        "x": 0,
        "y": 189
      },
      "id": 226,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"dependencies\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Dependencies Machine",
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
        "h": 5,
        "w": 12,
        "x": 12,
        "y": 189
      },
      "id": 227,
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
          "expr": "count by (label_beta_kubernetes_io_instance_type) (kube_node_labels{label_node=\"dependencies\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Dependencies Machine Count",
      "type": "stat"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 194
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
                "color": "#8438fa",
                "value": null
              }
            ]
          },
          "unit": "core"
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 0,
        "y": 195
      },
      "id": 231,
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
          "expr": "kube_pod_container_resource_requests{container=\"gateway-tyk-gateway\",resource=\"cpu\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Containers CPU Requests",
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
          "unit": "core"
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 4,
        "y": 195
      },
      "id": 232,
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
          "expr": "kube_pod_container_resource_limits{container=\"gateway-tyk-gateway\",resource=\"cpu\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Containers CPU Limits",
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
          "unit": "core"
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 8,
        "y": 195
      },
      "id": 233,
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
          "expr": "kube_pod_container_resource_requests{container=\"proxy\",resource=\"cpu\", namespace=\"kong\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Containers CPU Requests",
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
          "unit": "core"
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 12,
        "y": 195
      },
      "id": 234,
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
          "expr": "kube_pod_container_resource_limits{container=\"proxy\",resource=\"cpu\",namespace=\"kong\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Containers CPU Limits",
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
          "unit": "core"
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 16,
        "y": 195
      },
      "id": 235,
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
          "expr": "kube_pod_container_resource_requests{container=\"gravitee-apim-gateway\",resource=\"cpu\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Containers CPU Requests",
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
          "unit": "core"
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 195
      },
      "id": 236,
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
          "expr": "kube_pod_container_resource_limits{container=\"gravitee-apim-gateway\",resource=\"cpu\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Containers CPU Limits",
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
          "unit": "core"
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 0,
        "y": 200
      },
      "id": 243,
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
          "expr": "sum(kube_pod_container_resource_requests{container=\"gateway-tyk-gateway\",resource=\"cpu\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Total CPU Requests",
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
          "unit": "core"
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 4,
        "y": 200
      },
      "id": 244,
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
          "expr": "sum(kube_pod_container_resource_limits{container=\"gateway-tyk-gateway\",resource=\"cpu\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Total CPU Limits",
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
          "unit": "core"
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 8,
        "y": 200
      },
      "id": 245,
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
          "expr": "sum(kube_pod_container_resource_requests{container=\"proxy\",resource=\"cpu\", namespace=\"kong\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Total CPU Requests",
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
          "unit": "core"
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 12,
        "y": 200
      },
      "id": 246,
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
          "expr": "sum(kube_pod_container_resource_limits{container=\"proxy\",resource=\"cpu\",namespace=\"kong\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Total CPU Limits",
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
          "unit": "core"
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 16,
        "y": 200
      },
      "id": 247,
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
          "expr": "sum(kube_pod_container_resource_requests{container=\"gravitee-apim-gateway\",resource=\"cpu\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Total CPU Requests",
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
          "unit": "core"
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 200
      },
      "id": 248,
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
          "expr": "sum(kube_pod_container_resource_limits{container=\"gravitee-apim-gateway\",resource=\"cpu\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Total CPU Limits",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 0,
        "y": 205
      },
      "id": 237,
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
          "expr": "kube_pod_container_resource_requests{container=\"gateway-tyk-gateway\",resource=\"memory\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Containers Memory Requests",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 4,
        "y": 205
      },
      "id": 238,
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
          "expr": "kube_pod_container_resource_limits{container=\"gateway-tyk-gateway\",resource=\"memory\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Containers Memory Limits",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 8,
        "y": 205
      },
      "id": 239,
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
          "expr": "kube_pod_container_resource_requests{container=\"proxy\",resource=\"memory\",namespace=\"kong\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Containers Memory Requests",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 12,
        "y": 205
      },
      "id": 240,
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
          "expr": "kube_pod_container_resource_limits{container=\"proxy\",resource=\"memory\",namespace=\"kong\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Containers Memory Limits",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 16,
        "y": 205
      },
      "id": 241,
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
          "expr": "kube_pod_container_resource_requests{container=\"gravitee-apim-gateway\",resource=\"memory\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Containers Memory Requests",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 205
      },
      "id": 242,
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
          "expr": "kube_pod_container_resource_limits{container=\"gravitee-apim-gateway\",resource=\"memory\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Containers Memory Limits",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 0,
        "y": 210
      },
      "id": 249,
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
          "expr": "sum(kube_pod_container_resource_requests{container=\"gateway-tyk-gateway\",resource=\"memory\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Total Memory Requests",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 4,
        "y": 210
      },
      "id": 250,
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
          "expr": "sum(kube_pod_container_resource_limits{container=\"gateway-tyk-gateway\",resource=\"memory\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tyk Total Memory Limits",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 8,
        "y": 210
      },
      "id": 251,
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
          "expr": "sum(kube_pod_container_resource_requests{container=\"proxy\",resource=\"memory\",namespace=\"kong\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Total Memory Requests",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 12,
        "y": 210
      },
      "id": 252,
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
          "expr": "sum(kube_pod_container_resource_limits{container=\"proxy\",resource=\"memory\",namespace=\"kong\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Kong Total Memory Limits",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 16,
        "y": 210
      },
      "id": 253,
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
          "expr": "sum(kube_pod_container_resource_requests{container=\"gravitee-apim-gateway\",resource=\"memory\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Total Memory Requests",
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
          }
        ]
      },
      "gridPos": {
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 210
      },
      "id": 254,
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
          "expr": "sum(kube_pod_container_resource_limits{container=\"gravitee-apim-gateway\",resource=\"memory\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Gravitee Total Memory Limits",
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
  "uid": "01npcT44k",
  "version": 1,
  "weekStart": ""
}
EOF
  }
}
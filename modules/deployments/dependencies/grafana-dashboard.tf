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
  "id": 1,
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
      "id": 47,
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
          "mappings": [
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 0,
                  "text": "0"
                }
              },
              "type": "special"
            }
          ],
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
          "unit": "reqps"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "  -"
            },
            "properties": [
              {
                "id": "displayName",
                "value": "without testid -"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 13,
        "w": 6,
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
          "editorMode": "builder",
          "exemplar": false,
          "expr": "sum by(testid) (rate(k6_http_reqs_total{testid=~\"$testid\"}[$__rate_interval]))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}}  -",
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
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "text",
            "mode": "palette-classic"
          },
          "decimals": 2,
          "mappings": [
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 0,
                  "text": "0"
                }
              },
              "type": "special"
            }
          ],
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
          "unit": "s"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "  -"
            },
            "properties": [
              {
                "id": "displayName",
                "value": "without testid -"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 13,
        "w": 6,
        "x": 6,
        "y": 1
      },
      "id": 122,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
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
          "expr": "histogram_quantile(0.99, sum by(testid) (rate(k6_http_req_duration_seconds{testid=~\"$testid\"}[$__rate_interval])))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}}  -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "P99 Response Time",
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
          "mappings": [
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 0,
                  "text": "0"
                }
              },
              "type": "special"
            }
          ],
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
          "unit": "s"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "  -"
            },
            "properties": [
              {
                "id": "displayName",
                "value": "without testid -"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 13,
        "w": 6,
        "x": 12,
        "y": 1
      },
      "id": 52,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
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
          "expr": "histogram_quantile(0.95, sum by(testid) (rate(k6_http_req_duration_seconds{testid=~\"$testid\"}[$__rate_interval])))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}}  -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "P95 Response Time",
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
          "mappings": [
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 0,
                  "text": "0"
                }
              },
              "type": "special"
            }
          ],
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
          "unit": "s"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "  -"
            },
            "properties": [
              {
                "id": "displayName",
                "value": "without testid -"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 13,
        "w": 6,
        "x": 18,
        "y": 1
      },
      "id": 126,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
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
          "expr": "histogram_quantile(0.90, sum by(testid) (rate(k6_http_req_duration_seconds{testid=~\"$testid\"}[$__rate_interval])))",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}}  -",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "P90 Response Time",
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
        "overrides": []
      },
      "gridPos": {
        "h": 13,
        "w": 12,
        "x": 0,
        "y": 14
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
        "overrides": []
      },
      "gridPos": {
        "h": 13,
        "w": 12,
        "x": 12,
        "y": 14
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
        "h": 13,
        "w": 12,
        "x": 0,
        "y": 27
      },
      "id": 14,
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
          "expr": "sum by(testid) (rate(k6_http_reqs_total{testid=~\"$testid\"}[$__rate_interval]))",
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
          "expr": "avg by(testid) (sum by(testid) (rate(k6_http_reqs_total{testid=~\"$testid\", expected_response=\"false\"}[$__rate_interval])))",
          "hide": false,
          "instant": false,
          "legendFormat": "Failed Requests Rate  - {{testid}}",
          "range": true,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "(histogram_sum(rate(k6_http_req_duration_seconds{testid=~\"$testid\"}[$__rate_interval]))\n/\nhistogram_count(rate(k6_http_req_duration_seconds{testid=~\"$testid\"}[$__rate_interval]))) ",
          "hide": false,
          "legendFormat": "Response  Time (avg)  - {{testid}}",
          "range": true,
          "refId": "C"
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
          "mappings": [
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 0,
                  "text": "0"
                }
              },
              "type": "special"
            }
          ],
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
          "unit": "short"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": " -"
            },
            "properties": [
              {
                "id": "displayName",
                "value": "without testid -"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 13,
        "w": 6,
        "x": 12,
        "y": 27
      },
      "id": 49,
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
          "expr": "sum by(testid) (k6_http_reqs_total{testid=~\"$testid\"})",
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
            "fixedColor": "red",
            "mode": "palette-classic"
          },
          "mappings": [
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 0,
                  "text": "0"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "dark-blue",
                "value": null
              },
              {
                "color": "red",
                "value": 0
              }
            ]
          },
          "unit": "reqs"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": " -"
            },
            "properties": [
              {
                "id": "displayName",
                "value": "without testid"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 13,
        "w": 6,
        "x": 18,
        "y": 27
      },
      "id": 71,
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
          "editorMode": "builder",
          "exemplar": false,
          "expr": "sum by(testid) (k6_http_reqs_total{testid=~\"$testid\", expected_response=\"false\"})",
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
              "id": "byName",
              "options": "Received - "
            },
            "properties": [
              {
                "id": "displayName",
                "value": "Received - without testid"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Sent - "
            },
            "properties": [
              {
                "id": "displayName",
                "value": "Sent - without testid"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 13,
        "w": 12,
        "x": 0,
        "y": 40
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
          "expr": "avg by(testid)(sum by(testid)(irate(k6_data_received_total{testid=~\"$testid\"}[$__rate_interval])))",
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
          "expr": "avg by(testid)(sum by(testid)(irate(k6_data_sent_total{testid=~\"$testid\"}[$__rate_interval])))",
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
          "mappings": [
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 0,
                  "text": "0"
                }
              },
              "type": "special"
            }
          ],
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
          "unit": "decbytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": " -"
            },
            "properties": [
              {
                "id": "displayName",
                "value": "without testid -"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 13,
        "w": 6,
        "x": 12,
        "y": 40
      },
      "id": 64,
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
          "expr": "sum by(testid) (k6_data_sent_total{testid=~\"$testid\"})",
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
          "mappings": [
            {
              "options": {
                "match": "null+nan",
                "result": {
                  "index": 0,
                  "text": "0"
                }
              },
              "type": "special"
            }
          ],
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
          "unit": "decbytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "  -"
            },
            "properties": [
              {
                "id": "displayName",
                "value": "without testid -"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 13,
        "w": 6,
        "x": 18,
        "y": 40
      },
      "id": 63,
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
          "expr": "sum by(testid) (k6_data_received_total{testid=~\"$testid\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{testid}}  -",
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
        "y": 53
      },
      "id": 127,
      "panels": [],
      "title": "Gateway Resource Utilization",
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
        "overrides": []
      },
      "gridPos": {
        "h": 13,
        "w": 12,
        "x": 0,
        "y": 54
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
        "overrides": []
      },
      "gridPos": {
        "h": 13,
        "w": 12,
        "x": 12,
        "y": 54
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
        "h": 13,
        "w": 12,
        "x": 0,
        "y": 67
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
          "expr": "sum(rate(container_cpu_usage_seconds_total{node=\"tyk\", namespace=\"tyk\"}[5m])) by (node)",
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
        "overrides": []
      },
      "gridPos": {
        "h": 13,
        "w": 12,
        "x": 12,
        "y": 67
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
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 80
      },
      "id": 135,
      "panels": [],
      "title": "Resource Utilization",
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
        "h": 13,
        "w": 12,
        "x": 0,
        "y": 81
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
        "overrides": []
      },
      "gridPos": {
        "h": 13,
        "w": 12,
        "x": 12,
        "y": 81
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
        "h": 13,
        "w": 12,
        "x": 0,
        "y": 94
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
        "h": 13,
        "w": 12,
        "x": 12,
        "y": 94
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
        "allValue": ".*",
        "current": {
          "selected": true,
          "text": [
            "All"
          ],
          "value": [
            "$__all"
          ]
        },
        "datasource": {
          "type": "prometheus",
          "uid": "PBFA97CFB590B2093"
        },
        "definition": "label_values(testid)",
        "hide": 0,
        "includeAll": true,
        "multi": true,
        "name": "testid",
        "options": [],
        "query": {
          "query": "label_values(testid)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 2,
        "regex": "",
        "skipUrlSync": false,
        "sort": 3,
        "type": "query"
      },
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
    "from": "now-15m",
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
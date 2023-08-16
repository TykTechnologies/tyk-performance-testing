resource "kubernetes_config_map" "grafana-dashboard" {
  metadata {
    name      = "grafana-dashboards-configmap"
    namespace = var.namespace
  }

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
      "id": 47,
      "panels": [],
      "title": "Performance Overview",
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
        "h": 10,
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
            "max"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "10.0.3",
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
        "h": 10,
        "w": 4,
        "x": 4,
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
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "10.0.3",
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
      "transformations": [],
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
        "h": 10,
        "w": 4,
        "x": 8,
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
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "10.0.3",
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
      "transformations": [],
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
        "h": 10,
        "w": 4,
        "x": 12,
        "y": 1
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
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "10.0.3",
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
        "h": 10,
        "w": 4,
        "x": 16,
        "y": 1
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
        "text": {},
        "textMode": "value_and_name"
      },
      "pluginVersion": "10.0.3",
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
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 1
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
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "10.0.3",
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
        "h": 5,
        "w": 4,
        "x": 20,
        "y": 6
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
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "10.0.3",
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
        "h": 10,
        "w": 12,
        "x": 0,
        "y": 11
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
            "mode": "palette-classic"
          },
          "custom": {
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
        "h": 10,
        "w": 12,
        "x": 12,
        "y": 11
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
          "editorMode": "code",
          "expr": "100 - (avg by (node) (irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
          "instant": false,
          "range": true,
          "refId": "A"
        }
      ],
      "title": "CPU utilization per node",
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
        "h": 11,
        "w": 12,
        "x": 0,
        "y": 21
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
            "mode": "thresholds"
          },
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "auto"
            },
            "inspect": false
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
          }
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "testid"
            },
            "properties": [
              {
                "id": "mappings",
                "value": [
                  {
                    "options": {
                      "match": "null",
                      "result": {
                        "index": 0,
                        "text": "without testid"
                      }
                    },
                    "type": "special"
                  }
                ]
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 11,
        "w": 12,
        "x": 12,
        "y": 21
      },
      "id": 119,
      "options": {
        "cellHeight": "sm",
        "footer": {
          "countRows": false,
          "fields": "",
          "reducer": [
            "sum"
          ],
          "show": false
        },
        "frameIndex": 4,
        "showHeader": true
      },
      "pluginVersion": "10.0.3",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "PBFA97CFB590B2093"
          },
          "editorMode": "code",
          "expr": "k6_http_reqs_total{testid=~\"$testid\"}",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Tests in this Time Range",
      "transformations": [
        {
          "id": "joinByLabels",
          "options": {
            "value": "expected_response"
          }
        },
        {
          "id": "organize",
          "options": {
            "excludeByName": {
              "Time": true,
              "Value": true,
              "method": true,
              "proto": true,
              "scenario": true,
              "status": true,
              "tls_version": true,
              "true": true,
              "url": true
            },
            "indexByName": {
              "method": 2,
              "name": 1,
              "proto": 3,
              "scenario": 4,
              "status": 5,
              "testid": 0,
              "tls_version": 6,
              "true": 8,
              "url": 7
            },
            "renameByName": {}
          }
        },
        {
          "id": "groupBy",
          "options": {
            "fields": {
              "name": {
                "aggregations": [],
                "operation": "groupby"
              },
              "testid": {
                "aggregations": [],
                "operation": "groupby"
              }
            }
          }
        }
      ],
      "type": "table"
    }
  ],
  "refresh": "5s",
  "revision": 1,
  "schemaVersion": 38,
  "style": "dark",
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

  depends_on = [kubernetes_namespace.dependencies]
}
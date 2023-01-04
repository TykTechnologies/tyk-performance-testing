resource "kubernetes_manifest" "namespace_k6" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Namespace"
    "metadata" = {
      "labels" = {
        "app.kubernetes.io/name" = "k6-operator"
        "control-plane" = "controller-manager"
      }
      "name" = "k6"
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_k6s_k6_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "annotations" = {
        "controller-gen.kubebuilder.io/version" = "v0.3.0"
      }
      "name" = "k6s.k6.io"
    }
    "spec" = {
      "group" = "k6.io"
      "names" = {
        "kind" = "K6"
        "listKind" = "K6List"
        "plural" = "k6s"
        "singular" = "k6"
      }
      "scope" = "Namespaced"
      "versions" = [
        {
          "name" = "v1alpha1"
          "schema" = {
            "openAPIV3Schema" = {
              "description" = "K6 is the Schema for the k6s API"
              "properties" = {
                "apiVersion" = {
                  "description" = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
                  "type" = "string"
                }
                "kind" = {
                  "description" = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
                  "type" = "string"
                }
                "metadata" = {
                  "type" = "object"
                }
                "spec" = {
                  "description" = "K6Spec defines the desired state of K6"
                  "properties" = {
                    "arguments" = {
                      "type" = "string"
                    }
                    "cleanup" = {
                      "description" = "Cleanup allows for automatic cleanup of resources post execution"
                      "enum" = [
                        "post",
                      ]
                      "type" = "string"
                    }
                    "parallelism" = {
                      "format" = "int32"
                      "type" = "integer"
                    }
                    "paused" = {
                      "type" = "string"
                    }
                    "ports" = {
                      "items" = {
                        "description" = "ContainerPort represents a network port in a single container."
                        "properties" = {
                          "containerPort" = {
                            "description" = "Number of port to expose on the pod's IP address. This must be a valid port number, 0 < x < 65536."
                            "format" = "int32"
                            "type" = "integer"
                          }
                          "hostIP" = {
                            "description" = "What host IP to bind the external port to."
                            "type" = "string"
                          }
                          "hostPort" = {
                            "description" = "Number of port to expose on the host. If specified, this must be a valid port number, 0 < x < 65536. If HostNetwork is specified, this must match ContainerPort. Most containers do not need this."
                            "format" = "int32"
                            "type" = "integer"
                          }
                          "name" = {
                            "description" = "If specified, this must be an IANA_SVC_NAME and unique within the pod. Each named port in a pod must have a unique name. Name for the port that can be referred to by services."
                            "type" = "string"
                          }
                          "protocol" = {
                            "description" = "Protocol for port. Must be UDP, TCP, or SCTP. Defaults to \"TCP\"."
                            "type" = "string"
                          }
                        }
                        "required" = [
                          "containerPort",
                        ]
                        "type" = "object"
                      }
                      "type" = "array"
                    }
                    "quiet" = {
                      "type" = "string"
                    }
                    "runner" = {
                      "properties" = {
                        "affinity" = {
                          "description" = "Affinity is a group of affinity scheduling rules."
                          "properties" = {
                            "nodeAffinity" = {
                              "description" = "Describes node affinity scheduling rules for the pod."
                              "properties" = {
                                "preferredDuringSchedulingIgnoredDuringExecution" = {
                                  "description" = "The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding \"weight\" to the sum if the node matches the corresponding matchExpressions; the node(s) with the highest sum are the most preferred."
                                  "items" = {
                                    "description" = "An empty preferred scheduling term matches all objects with implicit weight 0 (i.e. it's a no-op). A null preferred scheduling term matches no objects (i.e. is also a no-op)."
                                    "properties" = {
                                      "preference" = {
                                        "description" = "A node selector term, associated with the corresponding weight."
                                        "properties" = {
                                          "matchExpressions" = {
                                            "description" = "A list of node selector requirements by node's labels."
                                            "items" = {
                                              "description" = "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                              "properties" = {
                                                "key" = {
                                                  "description" = "The label key that the selector applies to."
                                                  "type" = "string"
                                                }
                                                "operator" = {
                                                  "description" = "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."
                                                  "type" = "string"
                                                }
                                                "values" = {
                                                  "description" = "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."
                                                  "items" = {
                                                    "type" = "string"
                                                  }
                                                  "type" = "array"
                                                }
                                              }
                                              "required" = [
                                                "key",
                                                "operator",
                                              ]
                                              "type" = "object"
                                            }
                                            "type" = "array"
                                          }
                                          "matchFields" = {
                                            "description" = "A list of node selector requirements by node's fields."
                                            "items" = {
                                              "description" = "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                              "properties" = {
                                                "key" = {
                                                  "description" = "The label key that the selector applies to."
                                                  "type" = "string"
                                                }
                                                "operator" = {
                                                  "description" = "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."
                                                  "type" = "string"
                                                }
                                                "values" = {
                                                  "description" = "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."
                                                  "items" = {
                                                    "type" = "string"
                                                  }
                                                  "type" = "array"
                                                }
                                              }
                                              "required" = [
                                                "key",
                                                "operator",
                                              ]
                                              "type" = "object"
                                            }
                                            "type" = "array"
                                          }
                                        }
                                        "type" = "object"
                                      }
                                      "weight" = {
                                        "description" = "Weight associated with matching the corresponding nodeSelectorTerm, in the range 1-100."
                                        "format" = "int32"
                                        "type" = "integer"
                                      }
                                    }
                                    "required" = [
                                      "preference",
                                      "weight",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "requiredDuringSchedulingIgnoredDuringExecution" = {
                                  "description" = "If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to an update), the system may or may not try to eventually evict the pod from its node."
                                  "properties" = {
                                    "nodeSelectorTerms" = {
                                      "description" = "Required. A list of node selector terms. The terms are ORed."
                                      "items" = {
                                        "description" = "A null or empty node selector term matches no objects. The requirements of them are ANDed. The TopologySelectorTerm type implements a subset of the NodeSelectorTerm."
                                        "properties" = {
                                          "matchExpressions" = {
                                            "description" = "A list of node selector requirements by node's labels."
                                            "items" = {
                                              "description" = "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                              "properties" = {
                                                "key" = {
                                                  "description" = "The label key that the selector applies to."
                                                  "type" = "string"
                                                }
                                                "operator" = {
                                                  "description" = "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."
                                                  "type" = "string"
                                                }
                                                "values" = {
                                                  "description" = "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."
                                                  "items" = {
                                                    "type" = "string"
                                                  }
                                                  "type" = "array"
                                                }
                                              }
                                              "required" = [
                                                "key",
                                                "operator",
                                              ]
                                              "type" = "object"
                                            }
                                            "type" = "array"
                                          }
                                          "matchFields" = {
                                            "description" = "A list of node selector requirements by node's fields."
                                            "items" = {
                                              "description" = "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                              "properties" = {
                                                "key" = {
                                                  "description" = "The label key that the selector applies to."
                                                  "type" = "string"
                                                }
                                                "operator" = {
                                                  "description" = "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."
                                                  "type" = "string"
                                                }
                                                "values" = {
                                                  "description" = "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."
                                                  "items" = {
                                                    "type" = "string"
                                                  }
                                                  "type" = "array"
                                                }
                                              }
                                              "required" = [
                                                "key",
                                                "operator",
                                              ]
                                              "type" = "object"
                                            }
                                            "type" = "array"
                                          }
                                        }
                                        "type" = "object"
                                      }
                                      "type" = "array"
                                    }
                                  }
                                  "required" = [
                                    "nodeSelectorTerms",
                                  ]
                                  "type" = "object"
                                }
                              }
                              "type" = "object"
                            }
                            "podAffinity" = {
                              "description" = "Describes pod affinity scheduling rules (e.g. co-locate this pod in the same node, zone, etc. as some other pod(s))."
                              "properties" = {
                                "preferredDuringSchedulingIgnoredDuringExecution" = {
                                  "description" = "The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding \"weight\" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred."
                                  "items" = {
                                    "description" = "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)"
                                    "properties" = {
                                      "podAffinityTerm" = {
                                        "description" = "Required. A pod affinity term, associated with the corresponding weight."
                                        "properties" = {
                                          "labelSelector" = {
                                            "description" = "A label query over a set of resources, in this case pods."
                                            "properties" = {
                                              "matchExpressions" = {
                                                "description" = "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                                "items" = {
                                                  "description" = "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                                  "properties" = {
                                                    "key" = {
                                                      "description" = "key is the label key that the selector applies to."
                                                      "type" = "string"
                                                    }
                                                    "operator" = {
                                                      "description" = "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                                      "type" = "string"
                                                    }
                                                    "values" = {
                                                      "description" = "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                                      "items" = {
                                                        "type" = "string"
                                                      }
                                                      "type" = "array"
                                                    }
                                                  }
                                                  "required" = [
                                                    "key",
                                                    "operator",
                                                  ]
                                                  "type" = "object"
                                                }
                                                "type" = "array"
                                              }
                                              "matchLabels" = {
                                                "additionalProperties" = {
                                                  "type" = "string"
                                                }
                                                "description" = "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                                "type" = "object"
                                              }
                                            }
                                            "type" = "object"
                                          }
                                          "namespaces" = {
                                            "description" = "namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means \"this pod's namespace\""
                                            "items" = {
                                              "type" = "string"
                                            }
                                            "type" = "array"
                                          }
                                          "topologyKey" = {
                                            "description" = "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed."
                                            "type" = "string"
                                          }
                                        }
                                        "required" = [
                                          "topologyKey",
                                        ]
                                        "type" = "object"
                                      }
                                      "weight" = {
                                        "description" = "weight associated with matching the corresponding podAffinityTerm, in the range 1-100."
                                        "format" = "int32"
                                        "type" = "integer"
                                      }
                                    }
                                    "required" = [
                                      "podAffinityTerm",
                                      "weight",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "requiredDuringSchedulingIgnoredDuringExecution" = {
                                  "description" = "If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied."
                                  "items" = {
                                    "description" = "Defines a set of pods (namely those matching the labelSelector relative to the given namespace(s)) that this pod should be co-located (affinity) or not co-located (anti-affinity) with, where co-located is defined as running on a node whose value of the label with key <topologyKey> matches that of any node on which a pod of the set of pods is running"
                                    "properties" = {
                                      "labelSelector" = {
                                        "description" = "A label query over a set of resources, in this case pods."
                                        "properties" = {
                                          "matchExpressions" = {
                                            "description" = "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                            "items" = {
                                              "description" = "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                              "properties" = {
                                                "key" = {
                                                  "description" = "key is the label key that the selector applies to."
                                                  "type" = "string"
                                                }
                                                "operator" = {
                                                  "description" = "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                                  "type" = "string"
                                                }
                                                "values" = {
                                                  "description" = "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                                  "items" = {
                                                    "type" = "string"
                                                  }
                                                  "type" = "array"
                                                }
                                              }
                                              "required" = [
                                                "key",
                                                "operator",
                                              ]
                                              "type" = "object"
                                            }
                                            "type" = "array"
                                          }
                                          "matchLabels" = {
                                            "additionalProperties" = {
                                              "type" = "string"
                                            }
                                            "description" = "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                            "type" = "object"
                                          }
                                        }
                                        "type" = "object"
                                      }
                                      "namespaces" = {
                                        "description" = "namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means \"this pod's namespace\""
                                        "items" = {
                                          "type" = "string"
                                        }
                                        "type" = "array"
                                      }
                                      "topologyKey" = {
                                        "description" = "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed."
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "topologyKey",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                              }
                              "type" = "object"
                            }
                            "podAntiAffinity" = {
                              "description" = "Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in the same node, zone, etc. as some other pod(s))."
                              "properties" = {
                                "preferredDuringSchedulingIgnoredDuringExecution" = {
                                  "description" = "The scheduler will prefer to schedule pods to nodes that satisfy the anti-affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling anti-affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding \"weight\" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred."
                                  "items" = {
                                    "description" = "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)"
                                    "properties" = {
                                      "podAffinityTerm" = {
                                        "description" = "Required. A pod affinity term, associated with the corresponding weight."
                                        "properties" = {
                                          "labelSelector" = {
                                            "description" = "A label query over a set of resources, in this case pods."
                                            "properties" = {
                                              "matchExpressions" = {
                                                "description" = "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                                "items" = {
                                                  "description" = "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                                  "properties" = {
                                                    "key" = {
                                                      "description" = "key is the label key that the selector applies to."
                                                      "type" = "string"
                                                    }
                                                    "operator" = {
                                                      "description" = "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                                      "type" = "string"
                                                    }
                                                    "values" = {
                                                      "description" = "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                                      "items" = {
                                                        "type" = "string"
                                                      }
                                                      "type" = "array"
                                                    }
                                                  }
                                                  "required" = [
                                                    "key",
                                                    "operator",
                                                  ]
                                                  "type" = "object"
                                                }
                                                "type" = "array"
                                              }
                                              "matchLabels" = {
                                                "additionalProperties" = {
                                                  "type" = "string"
                                                }
                                                "description" = "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                                "type" = "object"
                                              }
                                            }
                                            "type" = "object"
                                          }
                                          "namespaces" = {
                                            "description" = "namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means \"this pod's namespace\""
                                            "items" = {
                                              "type" = "string"
                                            }
                                            "type" = "array"
                                          }
                                          "topologyKey" = {
                                            "description" = "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed."
                                            "type" = "string"
                                          }
                                        }
                                        "required" = [
                                          "topologyKey",
                                        ]
                                        "type" = "object"
                                      }
                                      "weight" = {
                                        "description" = "weight associated with matching the corresponding podAffinityTerm, in the range 1-100."
                                        "format" = "int32"
                                        "type" = "integer"
                                      }
                                    }
                                    "required" = [
                                      "podAffinityTerm",
                                      "weight",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "requiredDuringSchedulingIgnoredDuringExecution" = {
                                  "description" = "If the anti-affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the anti-affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied."
                                  "items" = {
                                    "description" = "Defines a set of pods (namely those matching the labelSelector relative to the given namespace(s)) that this pod should be co-located (affinity) or not co-located (anti-affinity) with, where co-located is defined as running on a node whose value of the label with key <topologyKey> matches that of any node on which a pod of the set of pods is running"
                                    "properties" = {
                                      "labelSelector" = {
                                        "description" = "A label query over a set of resources, in this case pods."
                                        "properties" = {
                                          "matchExpressions" = {
                                            "description" = "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                            "items" = {
                                              "description" = "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                              "properties" = {
                                                "key" = {
                                                  "description" = "key is the label key that the selector applies to."
                                                  "type" = "string"
                                                }
                                                "operator" = {
                                                  "description" = "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                                  "type" = "string"
                                                }
                                                "values" = {
                                                  "description" = "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                                  "items" = {
                                                    "type" = "string"
                                                  }
                                                  "type" = "array"
                                                }
                                              }
                                              "required" = [
                                                "key",
                                                "operator",
                                              ]
                                              "type" = "object"
                                            }
                                            "type" = "array"
                                          }
                                          "matchLabels" = {
                                            "additionalProperties" = {
                                              "type" = "string"
                                            }
                                            "description" = "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                            "type" = "object"
                                          }
                                        }
                                        "type" = "object"
                                      }
                                      "namespaces" = {
                                        "description" = "namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means \"this pod's namespace\""
                                        "items" = {
                                          "type" = "string"
                                        }
                                        "type" = "array"
                                      }
                                      "topologyKey" = {
                                        "description" = "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed."
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "topologyKey",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                              }
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                        "automountServiceAccountToken" = {
                          "type" = "string"
                        }
                        "env" = {
                          "items" = {
                            "description" = "EnvVar represents an environment variable present in a Container."
                            "properties" = {
                              "name" = {
                                "description" = "Name of the environment variable. Must be a C_IDENTIFIER."
                                "type" = "string"
                              }
                              "value" = {
                                "description" = "Variable references $(VAR_NAME) are expanded using the previous defined environment variables in the container and any service environment variables. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Defaults to \"\"."
                                "type" = "string"
                              }
                              "valueFrom" = {
                                "description" = "Source for the environment variable's value. Cannot be used if value is not empty."
                                "properties" = {
                                  "configMapKeyRef" = {
                                    "description" = "Selects a key of a ConfigMap."
                                    "properties" = {
                                      "key" = {
                                        "description" = "The key to select."
                                        "type" = "string"
                                      }
                                      "name" = {
                                        "description" = "Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?"
                                        "type" = "string"
                                      }
                                      "optional" = {
                                        "description" = "Specify whether the ConfigMap or its key must be defined"
                                        "type" = "boolean"
                                      }
                                    }
                                    "required" = [
                                      "key",
                                    ]
                                    "type" = "object"
                                  }
                                  "fieldRef" = {
                                    "description" = "Selects a field of the pod: supports metadata.name, metadata.namespace, metadata.labels, metadata.annotations, spec.nodeName, spec.serviceAccountName, status.hostIP, status.podIP, status.podIPs."
                                    "properties" = {
                                      "apiVersion" = {
                                        "description" = "Version of the schema the FieldPath is written in terms of, defaults to \"v1\"."
                                        "type" = "string"
                                      }
                                      "fieldPath" = {
                                        "description" = "Path of the field to select in the specified API version."
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "fieldPath",
                                    ]
                                    "type" = "object"
                                  }
                                  "resourceFieldRef" = {
                                    "description" = "Selects a resource of the container: only resources limits and requests (limits.cpu, limits.memory, limits.ephemeral-storage, requests.cpu, requests.memory and requests.ephemeral-storage) are currently supported."
                                    "properties" = {
                                      "containerName" = {
                                        "description" = "Container name: required for volumes, optional for env vars"
                                        "type" = "string"
                                      }
                                      "divisor" = {
                                        "anyOf" = [
                                          {
                                            "type" = "integer"
                                          },
                                          {
                                            "type" = "string"
                                          },
                                        ]
                                        "description" = "Specifies the output format of the exposed resources, defaults to \"1\""
                                        "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                        "x-kubernetes-int-or-string" = true
                                      }
                                      "resource" = {
                                        "description" = "Required: resource to select"
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "resource",
                                    ]
                                    "type" = "object"
                                  }
                                  "secretKeyRef" = {
                                    "description" = "Selects a key of a secret in the pod's namespace"
                                    "properties" = {
                                      "key" = {
                                        "description" = "The key of the secret to select from.  Must be a valid secret key."
                                        "type" = "string"
                                      }
                                      "name" = {
                                        "description" = "Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?"
                                        "type" = "string"
                                      }
                                      "optional" = {
                                        "description" = "Specify whether the Secret or its key must be defined"
                                        "type" = "boolean"
                                      }
                                    }
                                    "required" = [
                                      "key",
                                    ]
                                    "type" = "object"
                                  }
                                }
                                "type" = "object"
                              }
                            }
                            "required" = [
                              "name",
                            ]
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                        "envFrom" = {
                          "items" = {
                            "description" = "EnvFromSource represents the source of a set of ConfigMaps"
                            "properties" = {
                              "configMapRef" = {
                                "description" = "The ConfigMap to select from"
                                "properties" = {
                                  "name" = {
                                    "description" = "Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?"
                                    "type" = "string"
                                  }
                                  "optional" = {
                                    "description" = "Specify whether the ConfigMap must be defined"
                                    "type" = "boolean"
                                  }
                                }
                                "type" = "object"
                              }
                              "prefix" = {
                                "description" = "An optional identifier to prepend to each key in the ConfigMap. Must be a C_IDENTIFIER."
                                "type" = "string"
                              }
                              "secretRef" = {
                                "description" = "The Secret to select from"
                                "properties" = {
                                  "name" = {
                                    "description" = "Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?"
                                    "type" = "string"
                                  }
                                  "optional" = {
                                    "description" = "Specify whether the Secret must be defined"
                                    "type" = "boolean"
                                  }
                                }
                                "type" = "object"
                              }
                            }
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                        "image" = {
                          "type" = "string"
                        }
                        "imagePullSecrets" = {
                          "items" = {
                            "description" = "LocalObjectReference contains enough information to let you locate the referenced object inside the same namespace."
                            "properties" = {
                              "name" = {
                                "description" = "Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?"
                                "type" = "string"
                              }
                            }
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                        "metadata" = {
                          "properties" = {
                            "annotations" = {
                              "additionalProperties" = {
                                "type" = "string"
                              }
                              "type" = "object"
                            }
                            "labels" = {
                              "additionalProperties" = {
                                "type" = "string"
                              }
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                        "nodeselector" = {
                          "additionalProperties" = {
                            "type" = "string"
                          }
                          "type" = "object"
                        }
                        "resources" = {
                          "description" = "ResourceRequirements describes the compute resource requirements."
                          "properties" = {
                            "limits" = {
                              "additionalProperties" = {
                                "anyOf" = [
                                  {
                                    "type" = "integer"
                                  },
                                  {
                                    "type" = "string"
                                  },
                                ]
                                "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                "x-kubernetes-int-or-string" = true
                              }
                              "description" = "Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/"
                              "type" = "object"
                            }
                            "requests" = {
                              "additionalProperties" = {
                                "anyOf" = [
                                  {
                                    "type" = "integer"
                                  },
                                  {
                                    "type" = "string"
                                  },
                                ]
                                "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                "x-kubernetes-int-or-string" = true
                              }
                              "description" = "Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/"
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                        "securityContext" = {
                          "description" = "PodSecurityContext holds pod-level security attributes and common container settings. Some fields are also present in container.securityContext.  Field values of container.securityContext take precedence over field values of PodSecurityContext."
                          "properties" = {
                            "fsGroup" = {
                              "description" = <<-EOT
                              A special supplemental group that applies to all containers in a pod. Some volume types allow the Kubelet to change the ownership of that volume to be owned by the pod: 
                               1. The owning GID will be the FSGroup 2. The setgid bit is set (new files created in the volume will be owned by FSGroup) 3. The permission bits are OR'd with rw-rw---- 
                               If unset, the Kubelet will not modify the ownership and permissions of any volume.
                              EOT
                              "format" = "int64"
                              "type" = "integer"
                            }
                            "fsGroupChangePolicy" = {
                              "description" = "fsGroupChangePolicy defines behavior of changing ownership and permission of the volume before being exposed inside Pod. This field will only apply to volume types which support fsGroup based ownership(and permissions). It will have no effect on ephemeral volume types such as: secret, configmaps and emptydir. Valid values are \"OnRootMismatch\" and \"Always\". If not specified defaults to \"Always\"."
                              "type" = "string"
                            }
                            "runAsGroup" = {
                              "description" = "The GID to run the entrypoint of the container process. Uses runtime default if unset. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container."
                              "format" = "int64"
                              "type" = "integer"
                            }
                            "runAsNonRoot" = {
                              "description" = "Indicates that the container must run as a non-root user. If true, the Kubelet will validate the image at runtime to ensure that it does not run as UID 0 (root) and fail to start the container if it does. If unset or false, no such validation will be performed. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence."
                              "type" = "boolean"
                            }
                            "runAsUser" = {
                              "description" = "The UID to run the entrypoint of the container process. Defaults to user specified in image metadata if unspecified. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container."
                              "format" = "int64"
                              "type" = "integer"
                            }
                            "seLinuxOptions" = {
                              "description" = "The SELinux context to be applied to all containers. If unspecified, the container runtime will allocate a random SELinux context for each container.  May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container."
                              "properties" = {
                                "level" = {
                                  "description" = "Level is SELinux level label that applies to the container."
                                  "type" = "string"
                                }
                                "role" = {
                                  "description" = "Role is a SELinux role label that applies to the container."
                                  "type" = "string"
                                }
                                "type" = {
                                  "description" = "Type is a SELinux type label that applies to the container."
                                  "type" = "string"
                                }
                                "user" = {
                                  "description" = "User is a SELinux user label that applies to the container."
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                            "supplementalGroups" = {
                              "description" = "A list of groups applied to the first process run in each container, in addition to the container's primary GID.  If unspecified, no groups will be added to any container."
                              "items" = {
                                "format" = "int64"
                                "type" = "integer"
                              }
                              "type" = "array"
                            }
                            "sysctls" = {
                              "description" = "Sysctls hold a list of namespaced sysctls used for the pod. Pods with unsupported sysctls (by the container runtime) might fail to launch."
                              "items" = {
                                "description" = "Sysctl defines a kernel parameter to be set"
                                "properties" = {
                                  "name" = {
                                    "description" = "Name of a property to set"
                                    "type" = "string"
                                  }
                                  "value" = {
                                    "description" = "Value of a property to set"
                                    "type" = "string"
                                  }
                                }
                                "required" = [
                                  "name",
                                  "value",
                                ]
                                "type" = "object"
                              }
                              "type" = "array"
                            }
                            "windowsOptions" = {
                              "description" = "The Windows specific settings applied to all containers. If unspecified, the options within a container's SecurityContext will be used. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence."
                              "properties" = {
                                "gmsaCredentialSpec" = {
                                  "description" = "GMSACredentialSpec is where the GMSA admission webhook (https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the GMSA credential spec named by the GMSACredentialSpecName field."
                                  "type" = "string"
                                }
                                "gmsaCredentialSpecName" = {
                                  "description" = "GMSACredentialSpecName is the name of the GMSA credential spec to use."
                                  "type" = "string"
                                }
                                "runAsUserName" = {
                                  "description" = "The UserName in Windows to run the entrypoint of the container process. Defaults to the user specified in image metadata if unspecified. May also be set in PodSecurityContext. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence."
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                        "serviceAccountName" = {
                          "type" = "string"
                        }
                        "tolerations" = {
                          "items" = {
                            "description" = "The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>."
                            "properties" = {
                              "effect" = {
                                "description" = "Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute."
                                "type" = "string"
                              }
                              "key" = {
                                "description" = "Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys."
                                "type" = "string"
                              }
                              "operator" = {
                                "description" = "Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category."
                                "type" = "string"
                              }
                              "tolerationSeconds" = {
                                "description" = "TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system."
                                "format" = "int64"
                                "type" = "integer"
                              }
                              "value" = {
                                "description" = "Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string."
                                "type" = "string"
                              }
                            }
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                      }
                      "type" = "object"
                    }
                    "script" = {
                      "description" = "K6Script describes where the script to execute the tests is found"
                      "properties" = {
                        "configMap" = {
                          "description" = "K6Configmap describes the config map script location"
                          "properties" = {
                            "file" = {
                              "type" = "string"
                            }
                            "name" = {
                              "type" = "string"
                            }
                          }
                          "required" = [
                            "name",
                          ]
                          "type" = "object"
                        }
                        "localFile" = {
                          "type" = "string"
                        }
                        "volumeClaim" = {
                          "description" = "K6VolumeClaim describes the volume claim script location"
                          "properties" = {
                            "file" = {
                              "type" = "string"
                            }
                            "name" = {
                              "type" = "string"
                            }
                          }
                          "required" = [
                            "name",
                          ]
                          "type" = "object"
                        }
                      }
                      "type" = "object"
                    }
                    "scuttle" = {
                      "properties" = {
                        "enabled" = {
                          "type" = "string"
                        }
                        "envoyAdminApi" = {
                          "type" = "string"
                        }
                        "genericQuitEndpoint" = {
                          "type" = "string"
                        }
                        "istioQuitApi" = {
                          "type" = "string"
                        }
                        "neverKillIstio" = {
                          "type" = "boolean"
                        }
                        "neverKillIstioOnFailure" = {
                          "type" = "boolean"
                        }
                        "quitWithoutEnvoyTimeout" = {
                          "type" = "string"
                        }
                        "scuttleLogging" = {
                          "type" = "boolean"
                        }
                        "startWithoutEnvoy" = {
                          "type" = "boolean"
                        }
                        "waitForEnvoyTimeout" = {
                          "type" = "string"
                        }
                      }
                      "type" = "object"
                    }
                    "separate" = {
                      "type" = "boolean"
                    }
                    "starter" = {
                      "properties" = {
                        "affinity" = {
                          "description" = "Affinity is a group of affinity scheduling rules."
                          "properties" = {
                            "nodeAffinity" = {
                              "description" = "Describes node affinity scheduling rules for the pod."
                              "properties" = {
                                "preferredDuringSchedulingIgnoredDuringExecution" = {
                                  "description" = "The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding \"weight\" to the sum if the node matches the corresponding matchExpressions; the node(s) with the highest sum are the most preferred."
                                  "items" = {
                                    "description" = "An empty preferred scheduling term matches all objects with implicit weight 0 (i.e. it's a no-op). A null preferred scheduling term matches no objects (i.e. is also a no-op)."
                                    "properties" = {
                                      "preference" = {
                                        "description" = "A node selector term, associated with the corresponding weight."
                                        "properties" = {
                                          "matchExpressions" = {
                                            "description" = "A list of node selector requirements by node's labels."
                                            "items" = {
                                              "description" = "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                              "properties" = {
                                                "key" = {
                                                  "description" = "The label key that the selector applies to."
                                                  "type" = "string"
                                                }
                                                "operator" = {
                                                  "description" = "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."
                                                  "type" = "string"
                                                }
                                                "values" = {
                                                  "description" = "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."
                                                  "items" = {
                                                    "type" = "string"
                                                  }
                                                  "type" = "array"
                                                }
                                              }
                                              "required" = [
                                                "key",
                                                "operator",
                                              ]
                                              "type" = "object"
                                            }
                                            "type" = "array"
                                          }
                                          "matchFields" = {
                                            "description" = "A list of node selector requirements by node's fields."
                                            "items" = {
                                              "description" = "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                              "properties" = {
                                                "key" = {
                                                  "description" = "The label key that the selector applies to."
                                                  "type" = "string"
                                                }
                                                "operator" = {
                                                  "description" = "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."
                                                  "type" = "string"
                                                }
                                                "values" = {
                                                  "description" = "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."
                                                  "items" = {
                                                    "type" = "string"
                                                  }
                                                  "type" = "array"
                                                }
                                              }
                                              "required" = [
                                                "key",
                                                "operator",
                                              ]
                                              "type" = "object"
                                            }
                                            "type" = "array"
                                          }
                                        }
                                        "type" = "object"
                                      }
                                      "weight" = {
                                        "description" = "Weight associated with matching the corresponding nodeSelectorTerm, in the range 1-100."
                                        "format" = "int32"
                                        "type" = "integer"
                                      }
                                    }
                                    "required" = [
                                      "preference",
                                      "weight",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "requiredDuringSchedulingIgnoredDuringExecution" = {
                                  "description" = "If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to an update), the system may or may not try to eventually evict the pod from its node."
                                  "properties" = {
                                    "nodeSelectorTerms" = {
                                      "description" = "Required. A list of node selector terms. The terms are ORed."
                                      "items" = {
                                        "description" = "A null or empty node selector term matches no objects. The requirements of them are ANDed. The TopologySelectorTerm type implements a subset of the NodeSelectorTerm."
                                        "properties" = {
                                          "matchExpressions" = {
                                            "description" = "A list of node selector requirements by node's labels."
                                            "items" = {
                                              "description" = "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                              "properties" = {
                                                "key" = {
                                                  "description" = "The label key that the selector applies to."
                                                  "type" = "string"
                                                }
                                                "operator" = {
                                                  "description" = "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."
                                                  "type" = "string"
                                                }
                                                "values" = {
                                                  "description" = "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."
                                                  "items" = {
                                                    "type" = "string"
                                                  }
                                                  "type" = "array"
                                                }
                                              }
                                              "required" = [
                                                "key",
                                                "operator",
                                              ]
                                              "type" = "object"
                                            }
                                            "type" = "array"
                                          }
                                          "matchFields" = {
                                            "description" = "A list of node selector requirements by node's fields."
                                            "items" = {
                                              "description" = "A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                              "properties" = {
                                                "key" = {
                                                  "description" = "The label key that the selector applies to."
                                                  "type" = "string"
                                                }
                                                "operator" = {
                                                  "description" = "Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt."
                                                  "type" = "string"
                                                }
                                                "values" = {
                                                  "description" = "An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch."
                                                  "items" = {
                                                    "type" = "string"
                                                  }
                                                  "type" = "array"
                                                }
                                              }
                                              "required" = [
                                                "key",
                                                "operator",
                                              ]
                                              "type" = "object"
                                            }
                                            "type" = "array"
                                          }
                                        }
                                        "type" = "object"
                                      }
                                      "type" = "array"
                                    }
                                  }
                                  "required" = [
                                    "nodeSelectorTerms",
                                  ]
                                  "type" = "object"
                                }
                              }
                              "type" = "object"
                            }
                            "podAffinity" = {
                              "description" = "Describes pod affinity scheduling rules (e.g. co-locate this pod in the same node, zone, etc. as some other pod(s))."
                              "properties" = {
                                "preferredDuringSchedulingIgnoredDuringExecution" = {
                                  "description" = "The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding \"weight\" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred."
                                  "items" = {
                                    "description" = "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)"
                                    "properties" = {
                                      "podAffinityTerm" = {
                                        "description" = "Required. A pod affinity term, associated with the corresponding weight."
                                        "properties" = {
                                          "labelSelector" = {
                                            "description" = "A label query over a set of resources, in this case pods."
                                            "properties" = {
                                              "matchExpressions" = {
                                                "description" = "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                                "items" = {
                                                  "description" = "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                                  "properties" = {
                                                    "key" = {
                                                      "description" = "key is the label key that the selector applies to."
                                                      "type" = "string"
                                                    }
                                                    "operator" = {
                                                      "description" = "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                                      "type" = "string"
                                                    }
                                                    "values" = {
                                                      "description" = "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                                      "items" = {
                                                        "type" = "string"
                                                      }
                                                      "type" = "array"
                                                    }
                                                  }
                                                  "required" = [
                                                    "key",
                                                    "operator",
                                                  ]
                                                  "type" = "object"
                                                }
                                                "type" = "array"
                                              }
                                              "matchLabels" = {
                                                "additionalProperties" = {
                                                  "type" = "string"
                                                }
                                                "description" = "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                                "type" = "object"
                                              }
                                            }
                                            "type" = "object"
                                          }
                                          "namespaces" = {
                                            "description" = "namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means \"this pod's namespace\""
                                            "items" = {
                                              "type" = "string"
                                            }
                                            "type" = "array"
                                          }
                                          "topologyKey" = {
                                            "description" = "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed."
                                            "type" = "string"
                                          }
                                        }
                                        "required" = [
                                          "topologyKey",
                                        ]
                                        "type" = "object"
                                      }
                                      "weight" = {
                                        "description" = "weight associated with matching the corresponding podAffinityTerm, in the range 1-100."
                                        "format" = "int32"
                                        "type" = "integer"
                                      }
                                    }
                                    "required" = [
                                      "podAffinityTerm",
                                      "weight",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "requiredDuringSchedulingIgnoredDuringExecution" = {
                                  "description" = "If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied."
                                  "items" = {
                                    "description" = "Defines a set of pods (namely those matching the labelSelector relative to the given namespace(s)) that this pod should be co-located (affinity) or not co-located (anti-affinity) with, where co-located is defined as running on a node whose value of the label with key <topologyKey> matches that of any node on which a pod of the set of pods is running"
                                    "properties" = {
                                      "labelSelector" = {
                                        "description" = "A label query over a set of resources, in this case pods."
                                        "properties" = {
                                          "matchExpressions" = {
                                            "description" = "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                            "items" = {
                                              "description" = "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                              "properties" = {
                                                "key" = {
                                                  "description" = "key is the label key that the selector applies to."
                                                  "type" = "string"
                                                }
                                                "operator" = {
                                                  "description" = "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                                  "type" = "string"
                                                }
                                                "values" = {
                                                  "description" = "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                                  "items" = {
                                                    "type" = "string"
                                                  }
                                                  "type" = "array"
                                                }
                                              }
                                              "required" = [
                                                "key",
                                                "operator",
                                              ]
                                              "type" = "object"
                                            }
                                            "type" = "array"
                                          }
                                          "matchLabels" = {
                                            "additionalProperties" = {
                                              "type" = "string"
                                            }
                                            "description" = "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                            "type" = "object"
                                          }
                                        }
                                        "type" = "object"
                                      }
                                      "namespaces" = {
                                        "description" = "namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means \"this pod's namespace\""
                                        "items" = {
                                          "type" = "string"
                                        }
                                        "type" = "array"
                                      }
                                      "topologyKey" = {
                                        "description" = "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed."
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "topologyKey",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                              }
                              "type" = "object"
                            }
                            "podAntiAffinity" = {
                              "description" = "Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in the same node, zone, etc. as some other pod(s))."
                              "properties" = {
                                "preferredDuringSchedulingIgnoredDuringExecution" = {
                                  "description" = "The scheduler will prefer to schedule pods to nodes that satisfy the anti-affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling anti-affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding \"weight\" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred."
                                  "items" = {
                                    "description" = "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)"
                                    "properties" = {
                                      "podAffinityTerm" = {
                                        "description" = "Required. A pod affinity term, associated with the corresponding weight."
                                        "properties" = {
                                          "labelSelector" = {
                                            "description" = "A label query over a set of resources, in this case pods."
                                            "properties" = {
                                              "matchExpressions" = {
                                                "description" = "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                                "items" = {
                                                  "description" = "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                                  "properties" = {
                                                    "key" = {
                                                      "description" = "key is the label key that the selector applies to."
                                                      "type" = "string"
                                                    }
                                                    "operator" = {
                                                      "description" = "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                                      "type" = "string"
                                                    }
                                                    "values" = {
                                                      "description" = "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                                      "items" = {
                                                        "type" = "string"
                                                      }
                                                      "type" = "array"
                                                    }
                                                  }
                                                  "required" = [
                                                    "key",
                                                    "operator",
                                                  ]
                                                  "type" = "object"
                                                }
                                                "type" = "array"
                                              }
                                              "matchLabels" = {
                                                "additionalProperties" = {
                                                  "type" = "string"
                                                }
                                                "description" = "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                                "type" = "object"
                                              }
                                            }
                                            "type" = "object"
                                          }
                                          "namespaces" = {
                                            "description" = "namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means \"this pod's namespace\""
                                            "items" = {
                                              "type" = "string"
                                            }
                                            "type" = "array"
                                          }
                                          "topologyKey" = {
                                            "description" = "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed."
                                            "type" = "string"
                                          }
                                        }
                                        "required" = [
                                          "topologyKey",
                                        ]
                                        "type" = "object"
                                      }
                                      "weight" = {
                                        "description" = "weight associated with matching the corresponding podAffinityTerm, in the range 1-100."
                                        "format" = "int32"
                                        "type" = "integer"
                                      }
                                    }
                                    "required" = [
                                      "podAffinityTerm",
                                      "weight",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                                "requiredDuringSchedulingIgnoredDuringExecution" = {
                                  "description" = "If the anti-affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the anti-affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied."
                                  "items" = {
                                    "description" = "Defines a set of pods (namely those matching the labelSelector relative to the given namespace(s)) that this pod should be co-located (affinity) or not co-located (anti-affinity) with, where co-located is defined as running on a node whose value of the label with key <topologyKey> matches that of any node on which a pod of the set of pods is running"
                                    "properties" = {
                                      "labelSelector" = {
                                        "description" = "A label query over a set of resources, in this case pods."
                                        "properties" = {
                                          "matchExpressions" = {
                                            "description" = "matchExpressions is a list of label selector requirements. The requirements are ANDed."
                                            "items" = {
                                              "description" = "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."
                                              "properties" = {
                                                "key" = {
                                                  "description" = "key is the label key that the selector applies to."
                                                  "type" = "string"
                                                }
                                                "operator" = {
                                                  "description" = "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."
                                                  "type" = "string"
                                                }
                                                "values" = {
                                                  "description" = "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."
                                                  "items" = {
                                                    "type" = "string"
                                                  }
                                                  "type" = "array"
                                                }
                                              }
                                              "required" = [
                                                "key",
                                                "operator",
                                              ]
                                              "type" = "object"
                                            }
                                            "type" = "array"
                                          }
                                          "matchLabels" = {
                                            "additionalProperties" = {
                                              "type" = "string"
                                            }
                                            "description" = "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."
                                            "type" = "object"
                                          }
                                        }
                                        "type" = "object"
                                      }
                                      "namespaces" = {
                                        "description" = "namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means \"this pod's namespace\""
                                        "items" = {
                                          "type" = "string"
                                        }
                                        "type" = "array"
                                      }
                                      "topologyKey" = {
                                        "description" = "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed."
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "topologyKey",
                                    ]
                                    "type" = "object"
                                  }
                                  "type" = "array"
                                }
                              }
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                        "automountServiceAccountToken" = {
                          "type" = "string"
                        }
                        "env" = {
                          "items" = {
                            "description" = "EnvVar represents an environment variable present in a Container."
                            "properties" = {
                              "name" = {
                                "description" = "Name of the environment variable. Must be a C_IDENTIFIER."
                                "type" = "string"
                              }
                              "value" = {
                                "description" = "Variable references $(VAR_NAME) are expanded using the previous defined environment variables in the container and any service environment variables. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Defaults to \"\"."
                                "type" = "string"
                              }
                              "valueFrom" = {
                                "description" = "Source for the environment variable's value. Cannot be used if value is not empty."
                                "properties" = {
                                  "configMapKeyRef" = {
                                    "description" = "Selects a key of a ConfigMap."
                                    "properties" = {
                                      "key" = {
                                        "description" = "The key to select."
                                        "type" = "string"
                                      }
                                      "name" = {
                                        "description" = "Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?"
                                        "type" = "string"
                                      }
                                      "optional" = {
                                        "description" = "Specify whether the ConfigMap or its key must be defined"
                                        "type" = "boolean"
                                      }
                                    }
                                    "required" = [
                                      "key",
                                    ]
                                    "type" = "object"
                                  }
                                  "fieldRef" = {
                                    "description" = "Selects a field of the pod: supports metadata.name, metadata.namespace, metadata.labels, metadata.annotations, spec.nodeName, spec.serviceAccountName, status.hostIP, status.podIP, status.podIPs."
                                    "properties" = {
                                      "apiVersion" = {
                                        "description" = "Version of the schema the FieldPath is written in terms of, defaults to \"v1\"."
                                        "type" = "string"
                                      }
                                      "fieldPath" = {
                                        "description" = "Path of the field to select in the specified API version."
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "fieldPath",
                                    ]
                                    "type" = "object"
                                  }
                                  "resourceFieldRef" = {
                                    "description" = "Selects a resource of the container: only resources limits and requests (limits.cpu, limits.memory, limits.ephemeral-storage, requests.cpu, requests.memory and requests.ephemeral-storage) are currently supported."
                                    "properties" = {
                                      "containerName" = {
                                        "description" = "Container name: required for volumes, optional for env vars"
                                        "type" = "string"
                                      }
                                      "divisor" = {
                                        "anyOf" = [
                                          {
                                            "type" = "integer"
                                          },
                                          {
                                            "type" = "string"
                                          },
                                        ]
                                        "description" = "Specifies the output format of the exposed resources, defaults to \"1\""
                                        "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                        "x-kubernetes-int-or-string" = true
                                      }
                                      "resource" = {
                                        "description" = "Required: resource to select"
                                        "type" = "string"
                                      }
                                    }
                                    "required" = [
                                      "resource",
                                    ]
                                    "type" = "object"
                                  }
                                  "secretKeyRef" = {
                                    "description" = "Selects a key of a secret in the pod's namespace"
                                    "properties" = {
                                      "key" = {
                                        "description" = "The key of the secret to select from.  Must be a valid secret key."
                                        "type" = "string"
                                      }
                                      "name" = {
                                        "description" = "Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?"
                                        "type" = "string"
                                      }
                                      "optional" = {
                                        "description" = "Specify whether the Secret or its key must be defined"
                                        "type" = "boolean"
                                      }
                                    }
                                    "required" = [
                                      "key",
                                    ]
                                    "type" = "object"
                                  }
                                }
                                "type" = "object"
                              }
                            }
                            "required" = [
                              "name",
                            ]
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                        "envFrom" = {
                          "items" = {
                            "description" = "EnvFromSource represents the source of a set of ConfigMaps"
                            "properties" = {
                              "configMapRef" = {
                                "description" = "The ConfigMap to select from"
                                "properties" = {
                                  "name" = {
                                    "description" = "Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?"
                                    "type" = "string"
                                  }
                                  "optional" = {
                                    "description" = "Specify whether the ConfigMap must be defined"
                                    "type" = "boolean"
                                  }
                                }
                                "type" = "object"
                              }
                              "prefix" = {
                                "description" = "An optional identifier to prepend to each key in the ConfigMap. Must be a C_IDENTIFIER."
                                "type" = "string"
                              }
                              "secretRef" = {
                                "description" = "The Secret to select from"
                                "properties" = {
                                  "name" = {
                                    "description" = "Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?"
                                    "type" = "string"
                                  }
                                  "optional" = {
                                    "description" = "Specify whether the Secret must be defined"
                                    "type" = "boolean"
                                  }
                                }
                                "type" = "object"
                              }
                            }
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                        "image" = {
                          "type" = "string"
                        }
                        "imagePullSecrets" = {
                          "items" = {
                            "description" = "LocalObjectReference contains enough information to let you locate the referenced object inside the same namespace."
                            "properties" = {
                              "name" = {
                                "description" = "Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?"
                                "type" = "string"
                              }
                            }
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                        "metadata" = {
                          "properties" = {
                            "annotations" = {
                              "additionalProperties" = {
                                "type" = "string"
                              }
                              "type" = "object"
                            }
                            "labels" = {
                              "additionalProperties" = {
                                "type" = "string"
                              }
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                        "nodeselector" = {
                          "additionalProperties" = {
                            "type" = "string"
                          }
                          "type" = "object"
                        }
                        "resources" = {
                          "description" = "ResourceRequirements describes the compute resource requirements."
                          "properties" = {
                            "limits" = {
                              "additionalProperties" = {
                                "anyOf" = [
                                  {
                                    "type" = "integer"
                                  },
                                  {
                                    "type" = "string"
                                  },
                                ]
                                "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                "x-kubernetes-int-or-string" = true
                              }
                              "description" = "Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/"
                              "type" = "object"
                            }
                            "requests" = {
                              "additionalProperties" = {
                                "anyOf" = [
                                  {
                                    "type" = "integer"
                                  },
                                  {
                                    "type" = "string"
                                  },
                                ]
                                "pattern" = "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
                                "x-kubernetes-int-or-string" = true
                              }
                              "description" = "Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/"
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                        "securityContext" = {
                          "description" = "PodSecurityContext holds pod-level security attributes and common container settings. Some fields are also present in container.securityContext.  Field values of container.securityContext take precedence over field values of PodSecurityContext."
                          "properties" = {
                            "fsGroup" = {
                              "description" = <<-EOT
                              A special supplemental group that applies to all containers in a pod. Some volume types allow the Kubelet to change the ownership of that volume to be owned by the pod: 
                               1. The owning GID will be the FSGroup 2. The setgid bit is set (new files created in the volume will be owned by FSGroup) 3. The permission bits are OR'd with rw-rw---- 
                               If unset, the Kubelet will not modify the ownership and permissions of any volume.
                              EOT
                              "format" = "int64"
                              "type" = "integer"
                            }
                            "fsGroupChangePolicy" = {
                              "description" = "fsGroupChangePolicy defines behavior of changing ownership and permission of the volume before being exposed inside Pod. This field will only apply to volume types which support fsGroup based ownership(and permissions). It will have no effect on ephemeral volume types such as: secret, configmaps and emptydir. Valid values are \"OnRootMismatch\" and \"Always\". If not specified defaults to \"Always\"."
                              "type" = "string"
                            }
                            "runAsGroup" = {
                              "description" = "The GID to run the entrypoint of the container process. Uses runtime default if unset. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container."
                              "format" = "int64"
                              "type" = "integer"
                            }
                            "runAsNonRoot" = {
                              "description" = "Indicates that the container must run as a non-root user. If true, the Kubelet will validate the image at runtime to ensure that it does not run as UID 0 (root) and fail to start the container if it does. If unset or false, no such validation will be performed. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence."
                              "type" = "boolean"
                            }
                            "runAsUser" = {
                              "description" = "The UID to run the entrypoint of the container process. Defaults to user specified in image metadata if unspecified. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container."
                              "format" = "int64"
                              "type" = "integer"
                            }
                            "seLinuxOptions" = {
                              "description" = "The SELinux context to be applied to all containers. If unspecified, the container runtime will allocate a random SELinux context for each container.  May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container."
                              "properties" = {
                                "level" = {
                                  "description" = "Level is SELinux level label that applies to the container."
                                  "type" = "string"
                                }
                                "role" = {
                                  "description" = "Role is a SELinux role label that applies to the container."
                                  "type" = "string"
                                }
                                "type" = {
                                  "description" = "Type is a SELinux type label that applies to the container."
                                  "type" = "string"
                                }
                                "user" = {
                                  "description" = "User is a SELinux user label that applies to the container."
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                            "supplementalGroups" = {
                              "description" = "A list of groups applied to the first process run in each container, in addition to the container's primary GID.  If unspecified, no groups will be added to any container."
                              "items" = {
                                "format" = "int64"
                                "type" = "integer"
                              }
                              "type" = "array"
                            }
                            "sysctls" = {
                              "description" = "Sysctls hold a list of namespaced sysctls used for the pod. Pods with unsupported sysctls (by the container runtime) might fail to launch."
                              "items" = {
                                "description" = "Sysctl defines a kernel parameter to be set"
                                "properties" = {
                                  "name" = {
                                    "description" = "Name of a property to set"
                                    "type" = "string"
                                  }
                                  "value" = {
                                    "description" = "Value of a property to set"
                                    "type" = "string"
                                  }
                                }
                                "required" = [
                                  "name",
                                  "value",
                                ]
                                "type" = "object"
                              }
                              "type" = "array"
                            }
                            "windowsOptions" = {
                              "description" = "The Windows specific settings applied to all containers. If unspecified, the options within a container's SecurityContext will be used. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence."
                              "properties" = {
                                "gmsaCredentialSpec" = {
                                  "description" = "GMSACredentialSpec is where the GMSA admission webhook (https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the GMSA credential spec named by the GMSACredentialSpecName field."
                                  "type" = "string"
                                }
                                "gmsaCredentialSpecName" = {
                                  "description" = "GMSACredentialSpecName is the name of the GMSA credential spec to use."
                                  "type" = "string"
                                }
                                "runAsUserName" = {
                                  "description" = "The UserName in Windows to run the entrypoint of the container process. Defaults to the user specified in image metadata if unspecified. May also be set in PodSecurityContext. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence."
                                  "type" = "string"
                                }
                              }
                              "type" = "object"
                            }
                          }
                          "type" = "object"
                        }
                        "serviceAccountName" = {
                          "type" = "string"
                        }
                        "tolerations" = {
                          "items" = {
                            "description" = "The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>."
                            "properties" = {
                              "effect" = {
                                "description" = "Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute."
                                "type" = "string"
                              }
                              "key" = {
                                "description" = "Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys."
                                "type" = "string"
                              }
                              "operator" = {
                                "description" = "Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category."
                                "type" = "string"
                              }
                              "tolerationSeconds" = {
                                "description" = "TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system."
                                "format" = "int64"
                                "type" = "integer"
                              }
                              "value" = {
                                "description" = "Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string."
                                "type" = "string"
                              }
                            }
                            "type" = "object"
                          }
                          "type" = "array"
                        }
                      }
                      "type" = "object"
                    }
                  }
                  "required" = [
                    "parallelism",
                    "script",
                  ]
                  "type" = "object"
                }
                "status" = {
                  "description" = "K6Status defines the observed state of K6"
                  "properties" = {
                    "stage" = {
                      "description" = "Stage describes which stage of the test execution lifecycle our runners are in"
                      "enum" = [
                        "initialization",
                        "initialized",
                        "created",
                        "started",
                        "finished",
                      ]
                      "type" = "string"
                    }
                  }
                  "type" = "object"
                }
              }
              "type" = "object"
            }
          }
          "served" = true
          "storage" = true
          "subresources" = {
            "status" = {}
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "serviceaccount_k6_k6_operator_controller" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "name" = "k6-operator-controller"
      "namespace" = "k6"
    }
  }
}

resource "kubernetes_manifest" "role_k6_k6_operator_leader_election_role" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "Role"
    "metadata" = {
      "name" = "k6-operator-leader-election-role"
      "namespace" = "k6"
    }
    "rules" = [
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "configmaps",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
          "delete",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "events",
        ]
        "verbs" = [
          "create",
          "patch",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrole_k6_operator_manager_role" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "k6-operator-manager-role"
    }
    "rules" = [
      {
        "apiGroups" = [
          "apps",
        ]
        "resources" = [
          "deployments",
        ]
        "verbs" = [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "batch",
        ]
        "resources" = [
          "jobs",
        ]
        "verbs" = [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "services",
        ]
        "verbs" = [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "pods",
          "pods/log",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "k6.io",
        ]
        "resources" = [
          "k6s",
        ]
        "verbs" = [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "k6.io",
        ]
        "resources" = [
          "k6s/status",
          "k6s/finalizers",
        ]
        "verbs" = [
          "get",
          "patch",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "secrets",
        ]
        "verbs" = [
          "list",
          "get",
          "watch",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrole_k6_operator_metrics_reader" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "k6-operator-metrics-reader"
    }
    "rules" = [
      {
        "nonResourceURLs" = [
          "/metrics",
        ]
        "verbs" = [
          "get",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrole_k6_operator_proxy_role" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "k6-operator-proxy-role"
    }
    "rules" = [
      {
        "apiGroups" = [
          "authentication.k8s.io",
        ]
        "resources" = [
          "tokenreviews",
        ]
        "verbs" = [
          "create",
        ]
      },
      {
        "apiGroups" = [
          "authorization.k8s.io",
        ]
        "resources" = [
          "subjectaccessreviews",
        ]
        "verbs" = [
          "create",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "rolebinding_k6_k6_operator_leader_election_rolebinding" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "RoleBinding"
    "metadata" = {
      "name" = "k6-operator-leader-election-rolebinding"
      "namespace" = "k6"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "Role"
      "name" = "k6-operator-leader-election-role"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "k6-operator-controller"
        "namespace" = "k6"
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_k6_operator_manager_rolebinding" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "name" = "k6-operator-manager-rolebinding"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "k6-operator-manager-role"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "k6-operator-controller"
        "namespace" = "k6"
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_k6_operator_proxy_rolebinding" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "name" = "k6-operator-proxy-rolebinding"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "k6-operator-proxy-role"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "k6-operator-controller"
        "namespace" = "k6"
      },
    ]
  }
}

resource "kubernetes_manifest" "service_k6_k6_operator_controller_manager_metrics_service" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "labels" = {
        "control-plane" = "controller-manager"
      }
      "name" = "k6-operator-controller-manager-metrics-service"
      "namespace" = "k6"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "https"
          "port" = 8443
          "targetPort" = "https"
        },
      ]
      "selector" = {
        "control-plane" = "controller-manager"
      }
    }
  }
}

resource "kubernetes_manifest" "deployment_k6_k6_operator_controller_manager" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "labels" = {
        "control-plane" = "controller-manager"
      }
      "name" = "k6-operator-controller-manager"
      "namespace" = "k6"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "control-plane" = "controller-manager"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "control-plane" = "controller-manager"
          }
        }
        "spec" = {
          "containers" = [
            {
              "args" = [
                "--secure-listen-address=0.0.0.0:8443",
                "--upstream=http://127.0.0.1:8080/",
                "--logtostderr=true",
                "--v=10",
              ]
              "image" = "gcr.io/kubebuilder/kube-rbac-proxy:v0.5.0"
              "name" = "kube-rbac-proxy"
              "ports" = [
                {
                  "containerPort" = 8443
                  "name" = "https"
                },
              ]
            },
            {
              "args" = [
                "--metrics-addr=127.0.0.1:8080",
                "--enable-leader-election",
              ]
              "command" = [
                "/manager",
              ]
              "image" = "ghcr.io/grafana/operator:latest"
              "name" = "manager"
              "resources" = {
                "limits" = {
                  "cpu" = "100m"
                  "memory" = "100Mi"
                }
                "requests" = {
                  "cpu" = "100m"
                  "memory" = "50Mi"
                }
              }
            },
          ]
          "serviceAccount" = "k6-operator-controller"
          "terminationGracePeriodSeconds" = 10
        }
      }
    }
  }
}

resource "kubectl_manifest" "subscription-keyless" {
  yaml_body = <<YAML
apiVersion: tyk.tyk.io/v1alpha1
kind: ApiDefinition
metadata:
  name: subscription-keyless
  namespace: ${var.namespace}
spec:
  name: subscription-keyless
  use_keyless: true
  protocol: http
  active: true
  proxy:
    target_url: http://notifications-graphql.upstream.svc:4104
    listen_path: /subscription-keyless
    strip_listen_path: true
  graphql:
    enabled: true
    execution_mode: proxyOnly
    playground:
      enabled: true
      path: /playground
    schema: |
      type Notification {
        id: ID!
        userId: ID!
        title: String!
        body: String!
      }

      type Query {
        placeholder: String
      }

      type Subscription {
        getUserNotifications(userId: ID!): [Notification!]!
      }
YAML

  depends_on = [helm_release.tyk-operator]
}

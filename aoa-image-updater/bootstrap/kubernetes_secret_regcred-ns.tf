resource "kubernetes_secret" "regcred-ns" {
  depends_on = [ 
    helm_release.this,
    kubernetes_namespace.this,
  ]
  metadata {
    name = "regcred"
    namespace = var.APP_K8S_NAMESPACE
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.REGISTRY_SERVER}" = {
          "username" = var.REGISTRY_USERNAME
          "password" = var.REGISTRY_PASSWORD
          "email"    = var.REGISTRY_EMAIL
          "auth"     = base64encode("${var.REGISTRY_USERNAME}:${var.REGISTRY_PASSWORD}")
        }
      }
    })
  }
}
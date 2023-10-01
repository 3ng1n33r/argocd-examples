resource "kubernetes_namespace" "this" {
  metadata {
    name = var.APP_K8S_NAMESPACE
  }
}
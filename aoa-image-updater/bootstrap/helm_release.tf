resource "helm_release" "this" {
  name       = "argocd"
  chart      = "../charts/argo-cd"
  namespace  = "argocd"
  create_namespace = true
}
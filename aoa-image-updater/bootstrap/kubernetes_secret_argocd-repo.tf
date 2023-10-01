resource "kubernetes_secret" "argocd-repo" {
  depends_on = [ 
    helm_release.this,
  ]
  metadata {
    name      = "argocd-repo"
    namespace = "argocd" 
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  type = "Opaque"

  data = {
    "password"  = var.ARGO_REPO_TOKEN
    "url"       = var.ARGO_REPO_URL
  }
}
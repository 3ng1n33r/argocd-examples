resource "kubernetes_secret" "gitlab-token" {
  depends_on = [ 
    helm_release.this,
  ]
  metadata {
    name      = "gitlab-token"
    namespace = "argocd"
  }

  type = "Opaque"

  data = {
    "username" = var.IMAGE_UPDATER_REPO_USER
    "password" = var.IMAGE_UPDATER_REPO_TOKEN
  }
}
resource "kubectl_manifest" "this" {
  depends_on = [ 
    helm_release.this,
    kubernetes_secret.argocd-repo,
  ]
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: apps
  namespace: argocd
spec:
  destination:
    namespace: argocd
    server: 'https://kubernetes.default.svc'
  source:
    helm:
      valueFiles:
        - values.yaml
    path: apps
    repoURL: 'https://gitlab.com/s045724/argo.git'
  project: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
YAML
}
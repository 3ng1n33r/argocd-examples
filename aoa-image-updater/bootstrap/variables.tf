variable "ARGO_REPO_TOKEN" {
  type = string
  description = "Enter the Project access token with api scope permissions: read_repository"
}

variable "ARGO_REPO_URL" {
  type = string
  description = "Enter the full repository URL (with .git at the end)"
  default = "https://gitlab.com/s045724/argo.git"
}

variable "IMAGE_UPDATER_REPO_USER" {
  type = string
  description = "Enter the Gitlab username"
  default = "s045724"
}

variable "IMAGE_UPDATER_REPO_TOKEN" {
  type = string
  description = "Enter the Project access token with api scope permissions: write_repository and Maintainer role"
}

variable "REGISTRY_SERVER" {
  type = string
  description = "Registry server"
  default = "https://index.docker.io/v1/"
}

variable "REGISTRY_USERNAME" {
  type = string
  description = "Registry username"
  default = "c8h11no2"
}

variable "REGISTRY_PASSWORD" {
  type = string
  description = "Registry token"
}

variable "REGISTRY_EMAIL" {
  type = string
  description = "Registry e-mail"
}

variable "APP_K8S_NAMESPACE" {
  type = string
  description = "Kubernetes Application namespace"
  default = "flask-app"
}
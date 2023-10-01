## ArgoCD image-updater
### Концепция 
Разворачиваем argocd из хелм-чарта, добавляем argo Application - App of Apps в котором три приложения, тот же чарт argocd, argocd-image-updater и хелм-чарт демо приложения. 

argocd-image-updater обновляет имидж демо приложения.

### Секреты
Нам понадобятся:

1.Токен для доступа к репозиторию (Gitlab)

**Settings - Access Tokens - Project Access Tokens - Add a project access token**

**Token name:** argo-cd

**Select a role:** Developer

**Select scopes:** read_repository

Пример команды:

`kubectl create secret generic argocd-repo --namespace=argocd --type=Opaque --from-literal=url=$repository --from-literal=password=$git_api_token`

2.Токен для argocd image-updater с возможностью делать коммиты в репозиторий (Gitlab)

**Settings - Access Tokens - Project Access Tokens - Add a project access token**

**Token name:** argo-cd-image-updater

**Select a role:** Maintainer

**Select scopes:** write_repository

Пример команды:

`kubectl create secret generic gitlab-token --namespace argocd --type=Opaque --from-literal=username=$gitlab_username --from-literal=password=$git_api_token_rw`

Пример манифеста:

```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  annotations:
    argocd-image-updater.argoproj.io/image-list: c8h11no2/flask-app
    argocd-image-updater.argoproj.io/write-back-method: git:secret:argocd/gitlab-token
    argocd-image-updater.argoproj.io/git-branch: main
```

3.Секрет для доступа к частному реджистри с имиджами (Docker Hub)

**Account Settings - Security - Access Tokens - New Access Tokens**

**Access Token Description:** docker-registry

**Access permissions:** Read-only

Пример команды:

`kubectl create secret docker-registry regcred --docker-server="https://index.docker.io/v1/" --docker-username=$docker_username --docker-password=$docker_token --docker-email=$docker_email -n flask-app`

Пример конфига для image-updater:

```
config:
  registries:
    - name: Docker Hub
      prefix: docker.io
      api_url: https://index.docker.io
      credentials: pullsecret:argocd/regcred
      defaultns: library
      default: true
```
Так же не забудем добавить в манифест деплоймента:

```
imagePullSecrets:
- name: regcred
```

### Развертывание

```
cd bootstrap
terraform init
terraform plan
terraform apply -auto-approve
```
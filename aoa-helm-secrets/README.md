## ArgoCD helm-secrets
### Концепция 
Разворачиваем argocd из хелм-чарта, добавляем argo Application - App of Apps в котором два приложения, тот же чарт argocd + `values/argocd.yaml` - вельюс файл с конфигом для реализации дешифрования. Второе приложение представляет из себя чарт prometheus с зашифрованным с помощью helm-secrets вельюс `values/prometheus.yaml`
### Требования

1) Устанавливаем helm-secrets через helm plugin:

`helm plugin install https://github.com/jkroepke/helm-secrets --version v3.15.0`

2) Устанавливаем зависимости (MacOS):

`brew install sops age`

3) Подготовим ключ, с помощью которого будут зашифровываться values-файлы:

`age-keygen -o key.txt`

> Public key: age1p22cjv8k50gav5zj8p9ct3fraqaqdg00xusvfqah5wh9qa9fhq8sezmk54

`export SOPS_AGE_KEY_FILE=$(pwd)/key.txt`

`export SOPS_AGE_RECIPIENTS=<публичный ключ, который распечатала команда выше>
`

### Справка по helm-secrets

* Расшифровать

`helm secrets dec values/prometheus.yaml`

> [helm-secrets] Decrypting values/prometheus.yaml

* Зашифровать

`helm secrets enc values/prometheus.yaml`

> Encrypting values/prometheus.yaml
> 
> Encrypted prometheus.yaml.dec to prometheus.yaml

`helm secrets clean .`

**Обязательно добавить в .gitignore файлы, чтобы исключить утечку ключа и расшифрованных секретов**

`echo 'key.txt' >> .gitignore`

`echo '*.dec' >> .gitignore`

### Подготовка
1) Получим токен. 

*Для Gitlab:*

**Settings - Access Tokens - Project Access Tokens - Add a project access token**

**Token name:** argo-cd

**Select a role:** Developer

**Select scopes:** read_repository

2) Сгенерируем ключ в директории bootstrap, как описано выше.

3) Зашифруем чувствительные данные в ``values/prometheus.yaml`` с помощью helm-secrets.

### Развертывание
`cd bootstrap
&& ./init.sh`
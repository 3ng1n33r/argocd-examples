#!/bin/bash

is_installed () {
   tools=( kubectl helm age-keygen )
   for i in "${tools[@]}"
   do
     if ! type $i &>/dev/null; then
       echo "$i required. Aborting ..."; exit 1
     fi
   done
}

key_checking () {
   SOPS_KEY_FILE=key.txt

   if [ -f $SOPS_KEY_FILE ]; then
     kubectl -n argocd create secret generic helm-secrets-private-keys --from-file=$SOPS_KEY_FILE
   else
     age-keygen -o $SOPS_KEY_FILE && kubectl -n argocd create secret generic helm-secrets-private-keys --from-file=$SOPS_KEY_FILE
     echo "Attention! A new key has been generated. It is required to use it to encrypt and decrypt data."
   fi
}

# Check binary installed
is_installed

# Create repository and API Token variables
read -p "Enter the full repository URL (with .git at the end): " repository
read -p "Enter the Git API token with api scope permissions: " git_api_token
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

# Installing and configuring Argocd 
helm install argocd ../charts/argo-cd --namespace argocd --create-namespace --atomic \
&& kubectl create secret generic argocd-repo --namespace=argocd --type=Opaque --from-literal=url=$repository --from-literal=password=$git_api_token \
&& kubectl label secret argocd-repo argocd.argoproj.io/secret-type=repository --namespace argocd \
&& key_checking \
&& sed -i.bak "s|___REPO_URL___|$repository|" manifests/application.yaml \
&& kubectl apply -f manifests/application.yaml
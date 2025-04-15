#!/bin/bash

set -e

ARGOCD_NAMESPACE="argocd"
ARGOCD_PROJECT_NAME="spring-boot-api-apps"
ARGOCD_PASSWORD="XAX3El7Wb7Ps6NqK"

REPO_URL="https://github.com/frapsky/spring-boot-api.git"
DEST_SERVER="https://kubernetes.default.svc"

argocd login localhost:8080 --username admin --password $ARGOCD_PASSWORD

argocd proj create "$ARGOCD_PROJECT_NAME" \
  --description "Project for Spring Boot API Applications" \
  --src "$REPO_URL" \
  --dest "$DEST_SERVER,*" \
  --upsert || error "Failed to create/update Argo CD project."

#argocd proj allow-namespace-resource "$ARGOCD_PROJECT_NAME" "*/*" || error "Failed to set namespaced resource permissions for project."

kubectl apply -f argocd/applicationset.yaml -n argocd
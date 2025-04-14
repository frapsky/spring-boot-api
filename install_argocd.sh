#!/bin/bash

set -e

ARGOCD_NAMESPACE="argocd"
HELM_RELEASE_NAME="argo-cd"
HELM_REPO_NAME="argo"
HELM_REPO_URL="https://argoproj.github.io/argo-helm"
HELM_CHART_NAME="argo-cd"
INSTALL_TIMEOUT="45m"


echo "1. Adding the Argo Project Helm repository"
helm repo add "${HELM_REPO_NAME}" "${HELM_REPO_URL}" --force-update || \
  echo "Helm repo '${HELM_REPO_NAME}' likely already exists. Continuing..."

echo "2. Updating Helm repositories"
helm repo update

echo "3. Creating namespace '${ARGOCD_NAMESPACE}'"
kubectl create namespace "${ARGOCD_NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f - || \
  echo "Namespace '${ARGOCD_NAMESPACE}'already exists. Continuing..."

echo "4. Installing Argo CD chart '${HELM_REPO_NAME}/${HELM_CHART_NAME}' as release '${HELM_RELEASE_NAME}'"
helm install "${HELM_RELEASE_NAME}" "${HELM_REPO_NAME}/${HELM_CHART_NAME}" \
  --namespace "${ARGOCD_NAMESPACE}" \
  --wait \
  --timeout "${INSTALL_TIMEOUT}"

echo "--- Argo CD Helm Installation Complete ---"
echo ""
echo "--- Verifying Installation ---"
echo "Helm release status:"
helm status "${HELM_RELEASE_NAME}" -n "${ARGOCD_NAMESPACE}"
echo ""
echo "Argo CD Pods:"
kubectl get pods -n "${ARGOCD_NAMESPACE}"
echo ""
echo "Script finished."

# NOTES:
# In order to access the server UI you have the following options:
# 1. kubectl port-forward service/argo-cd-argocd-server -n argocd 8080:443
#
#    and then open the browser on http://localhost:8080 and accept the certificate
#
# 2. enable ingress in the values file `server.ingress.enabled` and either
#      - Add the annotation for ssl passthrough: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-1-ssl-passthrough
#      - Set the `configs.params."server.insecure"` in the values file and terminate SSL at your ingress: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-2-multiple-ingress-objects-and-hosts
#
#
# After reaching the UI the first time you can login with username: admin and the random password generated during the installation. You can find the password by running:
#
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
#
# (You should delete the initial secret afterwards as suggested by the Getting Started Guide: https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli)
#
# Upgrading: helm upgrade ${HELM_RELEASE_NAME} ${HELM_REPO_NAME}/${HELM_CHART_NAME} -n ${ARGOCD_NAMESPACE}"
# Uninstalling: helm uninstall ${HELM_RELEASE_NAME} -n ${ARGOCD_NAMESPACE}"


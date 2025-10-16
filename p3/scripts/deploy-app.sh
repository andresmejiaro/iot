#!/bin/bash

# port forwarding
kubectl port-forward svc/argocd-server -n argocd 8080:443 &

# Get Argo CD initial admin password
ARGOCD_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 --decode)

yes | argocd login localhost:8080 --username admin --password "$ARGOCD_PWD" --insecure --port-forward-namespace argocd

# Create the Argo CD application
yes | argocd app create playground \
  --project default \
  --repo https://github.com/andresmejiaro/amejiaiot.git \
  --path wil \
  --revision HEAD \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev \
  --sync-policy automated \
  --auto-prune \
  --self-heal

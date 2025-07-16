

## From argo cd guide: https://argo-cd.readthedocs.io/en/stable/cli_installation/
if ! command -v argocd > argocd >/dev/null 2>&1; then
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64

## Expose services https://k3d.io/v5.3.0/usage/exposing_services/

k3d cluster create --api-port 6550 -p "8081:80@loadbalancer" -p "8443:443@loadbalancer" --agents 2

## create namespaces

kubectl apply -f confs/argocd-namespace.yaml 
kubectl apply -f confs/dev-namespace.yaml

## install argocd

kubectl apply -f confs/argocd/install.yaml -n argocd
kubectl apply -f confs/Ingress.yaml -n argocd

## patch the arcocd to allow insecure connections this solves Ingress issues

kubectl -n argocd patch deployment argocd-server \
  --type='json' \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--insecure"}]'
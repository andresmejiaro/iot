#! /bin/bash

sudo apt update
sudo apt install docker.io
sudo systemctl enable --now docker
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin 
mkdir -p infra/argocd/base
curl -sSL https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml \
  -o infra/argocd/base/install.yaml
curl -sSL -o /tmp/argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
install -m 555 /tmp/argocd-linux-amd64 /usr/local/bin/argocd
rm /tmp/argocd-linux-amd64

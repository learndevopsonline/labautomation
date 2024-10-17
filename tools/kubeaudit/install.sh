cd /tmp
curl -L -O https://github.com/Shopify/kubeaudit/releases/download/v0.22.2/kubeaudit_0.22.2_linux_amd64.tar.gz
tar -xf kubeaudit_0.22.2_linux_amd64.tar.gz
mv kubeaudit /bin
rm -f kubeaudit_0.22.2_linux_amd64.tar.gz

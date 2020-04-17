#!/bin/bash 

GO_VERSION=$(curl -L -s https://golang.org/dl/   | grep toggleVisible | head -1 | sed -e 's/"/ /g' |xargs -n 1  | grep ^go)
GO_URL="https://dl.google.com/go/${GO_VERSION}.linux-amd64.tar.gz"

cd /opt 
[ -d /opt/go ] && rm -rf /opt/go
curl -s $GO_URL | tar -xz  
ln -s /opt/go/bin/go /bin/go 
ln -s /opt/go/bin/gofmt /bin/gofmt 

# Go Dep 
export GOBIN=/opt/go/bin
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
ln -s /opt/go/bin/dep /bin/dep 

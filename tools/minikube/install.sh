#!/bin/bash

type minikube &>/dev/null
if [ $? -ne 0 ]; then
  dnf install https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
fi


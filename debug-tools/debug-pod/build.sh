#!/bin/bash

docker build -t ghcr.io/r-devops/debug .
docker push ghcr.io/r-devops/debug

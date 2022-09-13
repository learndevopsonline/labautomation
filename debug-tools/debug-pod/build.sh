#!/bin/bash

set -e -x

#docker build -t ghcr.io/r-devops/debug .
docker build -t rkalluru/debug:centos7 .
#docker push ghcr.io/r-devops/debug
docker push rkalluru/debug

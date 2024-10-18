#!/bin/sh
# rootless per: https://minikube.sigs.k8s.io/docs/drivers/podman/
#
# - these will require you to do a minikube delete and start
#
/usr/local/bin/minikube config set driver podman
/usr/local/bin/minikube config set rootless true

# start it using containerd for rootless
#
/usr/local/bin/minikube start --driver=podman --container-runtime=containerd
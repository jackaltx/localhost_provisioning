#!/bin.sh
# rootless per: https://minikube.sigs.k8s.io/docs/drivers/podman/
#
# - these will require you to do a minikube delete and start
#
minikube config set driver podman
minikube config set rootless true

# start it using containerd for rootless
#
minikube start --driver=podman --container-runtime=containerd

#!/usr/bin/env bash

# create minikube cluster

minikube start --vm driver kvm2

# also lets wait a momement to let minikube settle
echo "* will sleep for 60 seconds to give k8s minikube time to settle"
sleep 60

# enable minikube ingress

echo "* enabling ingress & metrics-server for hpa"
minikube addons enable ingress
minikube addons enable metrics-server

#!/usr/bin/env bash

# create minikube cluster

minikube start --vm driver kvm2

# also lets wait a momement to let minikube settle
echo "* will sleep for 120 seconds to give k8s minikube time to settle"
sleep 120

# enable minikube ingress

minikube addons enable ingress

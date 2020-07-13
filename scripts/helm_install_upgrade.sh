#!/usr/bin/env bash

# install prometheus-operator

kubectl create ns monitoring
helm -n monitoring upgrade --install prometheus-operator -f helmcharts/prometheus-operator/values.yaml helmcharts/prometheus-operator

# install via helm postgres chart

kubectl create ns postgres
helm -n postgres upgrade --install postgres -f helmcharts/postgresql/values.yaml helmcharts/postgresql/

# install simple-service

kubectl create ns simpleservice
helm -n simpleservice upgrade --install simpleservice -f helmcharts/simple-service/values.yaml helmcharts/simple-service/

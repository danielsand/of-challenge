#!/usr/bin/env bash

# install loki-stack
kubectl create ns loki
helm -n loki upgrade --install loki-stack -f helmcharts/loki-stack/values.yaml helmcharts/loki-stack

# install prometheus-operator
kubectl create ns monitoring
helm -n monitoring upgrade --install prometheus-operator -f helmcharts/prometheus-operator/values.yaml helmcharts/prometheus-operator

# install via helm postgres chart
kubectl create ns postgres
helm -n postgres upgrade --install postgres -f helmcharts/postgresql/values.yaml helmcharts/postgresql/

# install via helm postgres chart
kubectl create ns redis
helm -n redis upgrade --install redis -f helmcharts/redis/values.yaml helmcharts/redis/

# install simple-service
kubectl create ns simpleservice
helm -n simpleservice upgrade --install simpleservice -f helmcharts/simple-service/values.yaml helmcharts/simple-service/

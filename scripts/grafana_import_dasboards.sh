#!/usr/bin/env bash

cd hacks/grafana

# Postgres Grafana Dashboard
kubectl -n monitoring create cm grafana-postgres-overview --from-file=postgres-overview_rev2.json
kubectl -n monitoring label cm grafana-postgres-overview grafana_dashboard=postgres-overview

# Redis Dashboard

kubectl -n monitoring create cm grafana-redis-overview --from-file=redis-overview_rev1.json
kubectl -n monitoring label cm grafana-redis-overview grafana_dashboard=redis-overview




cd -

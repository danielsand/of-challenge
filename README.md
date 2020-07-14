# OF DevOps / SRE Challenge

Quickstart

```
git clone git@github.com:Onefootball-Core-Platform-Interviewer/Daniel.git
cd Daniel
bash turnkey.sh
```
or

[![Tour through the Challenge](https://i.pinimg.com/originals/7b/aa/25/7baa252dbdfeed669c152bedd2fa5feb.jpg)](https://youtu.be/ox_gZyX_oCA)


**TLDR**

This challenge was done under Manjaro (ArchLinux) and tested with the following setup to emulate K8S in a local running setup
( AMD Ryzen 9 3900X 12-Core Processor =] )

## Requirements

Linux / MacOS no Windows :D

- Docker 19.03.11-ce
- Minikube x.x.x
- Helm 3.2.4

## Setting up local FQDN DNS resolution

to have easy smooth dns resolving working locally and not IP kungfoo please add these lines to your **/etc/hosts** file

first get the Private IP of the Ingress

```
kubectl get ingress -A
```
should look like this
```
monitoring      prometheus-operator-alertmanager   <none>   alertmanager.ofc    192.168.99.100   80      109m
monitoring      prometheus-operator-grafana        <none>   grafana.ofc         192.168.99.100   80      109m
monitoring      prometheus-operator-prometheus     <none>   prometheus.ofc      192.168.99.100   80      109m
simpleservice   simpleservice-simple-service       <none>   simpleservice.ofc   192.168.99.100   80      7m
```

so **192.168.99.100** is mine.
replace <PUTYOURIPHERE> with yours =]

open **/etc/hosts** with your fav editor and add
```
<PUTYOURIPHERE> alertmanager.ofc
<PUTYOURIPHERE> grafana.ofc
<PUTYOURIPHERE> prometheus.ofc
<PUTYOURIPHERE> simpleservice.ofc
```

an now we have easy accessible FQDN from your local desktop useable

Example: http://simpleservice.ofc/live

TODO: if time - make this automatic via bash kungfo

## Local K8S setup

Minikube with KVM - docker gave me network trouble :/ and i dont wanted to waste more time to fix the docker overlay network.

KVM is Linux Native - so no MacOS Support AFAIK

Feature:
if it would be still alphaish :D

Kubernetes on firecracker (KVM)
https://github.com/weaveworks/ignite

## Simple Service

http://simpleservice.ofc

### Dockerfile

We use alpinelinux to build the simple-service golang code inside.
The simple-service binary is running as a non privileged user.

TODO: if time - switch to linuxkit https://github.com/linuxkit/kubernetes

### simple-service Helmchart

HPA is enabled

TODO: test it

## Helmcharts

we use Helm 3 to install some charts

#### postgres

```
PostgreSQL can be accessed via port 5432 on the following DNS name from within your cluster:

    postgres-postgresql.postgres.svc.cluster.local - Read/Write connection

To get the password for "postgres" run:

    export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)

To connect to your database run the following command:

    kubectl run postgres-postgresql-client --rm --tty -i --restart='Never' --namespace postgres --image docker.io/bitnami/postgresql:11.8.0-debian-10-r57 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgres-postgresql -U postgres -d postgres -p 5432
```

TODO: change the prometheus exporter at the end to https://github.com/wrouesnel/postgres_exporter it supports a nice grafana dashboard
https://grafana.com/grafana/dashboards/12485

#### prometheus-operator

configured to read all ServiceMonitors in all namespaces.

URL: http://prometheus.ofc/
URL: http://grafana.ofc/
URL: http://alertmanager.ofc/

TODO: make a nice overview dashboard for simple service

##### Redis

configured with ServiceMonitor default setup to add to simple-service as ping pong examples

```
** Please be patient while the chart is being deployed **
Redis can be accessed via port 6379 on the following DNS names from within your cluster:

redis-master.redis.svc.cluster.local for read/write operations
redis-slave.redis.svc.cluster.local for read-only operations


To get your password run:

    export REDIS_PASSWORD=$(kubectl get secret --namespace redis redis -o jsonpath="{.data.redis-password}" | base64 --decode)

To connect to your Redis server:

1. Run a Redis pod that you can use as a client:
   kubectl run --namespace redis redis-client --rm --tty -i --restart='Never' \
    --env REDIS_PASSWORD=$REDIS_PASSWORD \
   --image docker.io/bitnami/redis:6.0.5-debian-10-r32 -- bash

2. Connect using the Redis CLI:
   redis-cli -h redis-master -a $REDIS_PASSWORD
   redis-cli -h redis-slave -a $REDIS_PASSWORD
```

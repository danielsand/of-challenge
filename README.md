# OF DevOps / SRE Challenge

This challenge was done under ArchLinux and tested with the following setup to emulate K8S in a local running setup
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




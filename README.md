# OF DevOps / SRE Challenge

Quickstart

```
git clone git@github.com:Onefootball-Core-Platform-Interviewer/Daniel.git
cd Daniel
bash turnkey.sh
```
or click on the image to watch the **Tour through the Challenge Video**

[![Tour through the Challenge](https://img.youtube.com/vi/ox_gZyX_oCA/hqdefault.jpg)](https://youtu.be/ox_gZyX_oCA)

**TLDR**

This challenge was done under Manjaro (ArchLinux) and tested with the following setup to emulate K8S in a local running setup
( AMD Ryzen 9 3900X 12-Core Processor =] )

## Requirements

Linux / MacOS no Windows :D
( Linux needs KVM Support & packages installed )

- Docker 19.03.11-ce
- Minikube x.x.x
- Helm 3.2.4

## Getting Started

```
git clone git@github.com:Onefootball-Core-Platform-Interviewer/Daniel.git
cd Daniel
bash turnkey.sh
```

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

## Local K8S setup

Minikube with KVM - docker gave me network trouble :/ and i dont wanted to waste more time to fix the docker overlay network.

KVM is Linux Native - so no MacOS Support AFAIK

Feature:
if it would be still alphaish :D

Kubernetes on firecracker (KVM)
https://github.com/weaveworks/ignite

## Simple Service

http://simpleservice.ofc/live

### Dockerfile

We use alpinelinux to build the simple-service golang code inside.
The simple-service binary is running as a non privileged user.

also a nice -> linuxkit https://github.com/linuxkit/kubernetes

## simple-service Helmchart

HPA is enabled - but not working due to a bug

## Helmcharts

we use Helm 3 to install some charts

#### postgres

Grafana DashBoard: http://grafana.ofc/d/wGgaPlciz/postgres-overview

#### prometheus-operator

configured to read all ServiceMonitors in all namespaces.

URL: http://prometheus.ofc/
URL: http://grafana.ofc/
URL: http://alertmanager.ofc/

##### Redis

Grafana Dashboard: http://grafana.ofc/d/xDLNRKUWz/redis-dashboard-for-prometheus-redis-exporter

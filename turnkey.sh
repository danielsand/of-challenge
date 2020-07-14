#!/usr/bin/env bash

# lets check some commands we need

if ! command -v minikube &> /dev/null
then
    echo "* minikube binary could not be found"
    echo "* Please install it"
    exit
fi

if ! command -v kubectl &> /dev/null
then
    echo "* kubectl binary could not be found"
    echo "* Please install it"
    exit
fi

if ! command -v helm &> /dev/null
then
    echo "* helm 3 binary could not be found"
    echo "* Please install it"
    exit
fi

# lets find out what OS we are on and make some descissions
if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform
    echo "* macos ok lets try minikube - make sure its installed"
    bash scripts/bootstrap.sh
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
    echo "* Linux ! nice - lets try minikube with kvm. Make sure kvm packages are there"
    bash scripts/bootstrap_kvm.sh
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something under 32 bits Windows NT platform
    echo "Sorry - no windows :D"
    exit 1
    # Do something under 32 bits Windows NT platform
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # Do something under 64 bits Windows NT platform
    echo "Sorry - no windows :D"
    exit 1
fi

bash scripts/helm_install_upgrade.sh
bash scripts/grafana_import_dasboards.sh

echo "* sleep another 30 seconds - ingress needs a second to get started"

INGRESS_IP=`kubectl get ing -o wide -A |awk '{ print $5 }' |grep -v ADDRESS | uniq`

if [[ ! $INGRESS_IP ]]; then
  echo "! no ingress IP found - check your minikube cluster"
  exit 1
fi

echo "* Lets check if the /etc/hosts file is in the right setup with ${INGRESS_IP}"

if grep -q "${INGRESS_IP}" /etc/hosts ; then
  echo "* found ${INGRESS_IP} in /etc/hosts !"
  echo "* just go to http://simpleservice.ofc/"
  echo "* or http://grafana.ofc/ user: admin pw: prom-operator"
else
  echo "==========="
  echo "! WARNING !"
  echo "==========="
  echo "please add the following lines to your /etc/hosts file"
  echo "--------------------------------"
  echo "* Lets check if the /etc/hosts file is in the right setup with ${INGRESS_IP}"
  echo "${INGRESS_IP} alertmanager.ofc"
  echo "${INGRESS_IP} grafana.ofc"
  echo "${INGRESS_IP} prometheus.ofc"
  echo "${INGRESS_IP} simpleservice.ofc"
  echo "--------------------------------"
  echo "then you're good to go"
  echo "to http://simpleservice.ofc/live"
  echo "or http://grafana.ofc/ user: admin pw: prom-operator"
fi

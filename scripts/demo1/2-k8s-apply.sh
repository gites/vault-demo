#!/bin/bash

# create deployemtn with service accout cabable to authorize in vault

cd /vagrant/scripts/demo1/
. ../functions.sh

CMD_ARRAY=(
  "vimcat demo1-rbac.yaml"
  "kubectl apply -f demo1-rbac.yaml"
  "vimcat demo1-service-account.yaml"
  "kubectl apply -f demo1-service-account.yaml"
  "vimcat demo1-deployment.yaml"
  "kubectl apply -f demo1-deployment.yaml"
  "kubectl get po"
)

execute_array $CMD_ARRAY

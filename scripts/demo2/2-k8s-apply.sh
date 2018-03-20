#!/bin/bash

# create deployemtn with service accout cabable to authorize in vault

cd /vagrant/scripts/demo2/
. ../functions.sh

CMD_ARRAY=(
  "vimcat demo2-rbac.yaml"
  "kubectl apply -f demo2-rbac.yaml"
  "vimcat demo2-service-account.yaml"
  "kubectl apply -f demo2-service-account.yaml"
  "vimcat demo2-deployment.yaml"
  "kubectl apply -f demo2-deployment.yaml"
  "kubectl get po"
)

execute_array $CMD_ARRAY

#!/bin/bash

# create deployemtn with service accout cabable to authorize in vault

cd /vagrant/scripts/demo3/
. ../functions.sh

CMD_ARRAY=(
  "kubectl apply -f demo3-stuff.yaml"
  "vimcat demo3-stuff.yaml"
  "kubectl apply -f demo3-deployment.yaml"
  "vimcat demo3-deployment.yaml"
  "kubectl get po"
)

execute_array $CMD_ARRAY

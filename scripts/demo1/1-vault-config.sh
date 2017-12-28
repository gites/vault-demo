#!/bin/bash

# configure vault to authorize demo1 service account
# use permissions described in demo1-policy.hcl

cd /vagrant/scripts/demo1

. ../functions.sh

CMD_ARRAY=(
"vault policy-write demo1 demo1-policy.hcl"
"vimcat demo1-policy.hcl"
"vault write auth/kubernetes/role/demo1 bound_service_account_names=demo1 bound_service_account_namespaces=default policies=default,demo1 ttl=1h"
)

execute_array $CMD_ARRAY


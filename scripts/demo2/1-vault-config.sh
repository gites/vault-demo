#!/bin/bash

# configure vault to authorize demo2 service account
# use permissions described in demo2-policy.hcl

cd /vagrant/scripts/demo2

. ../functions.sh

CMD_ARRAY=(
"vault policy write demo2 demo2-policy.hcl"
"vimcat demo2-policy.hcl"
"vault write auth/kubernetes/role/demo2 bound_service_account_names=demo2 bound_service_account_namespaces=default policies=default,demo2 ttl=1h"
)

execute_array $CMD_ARRAY


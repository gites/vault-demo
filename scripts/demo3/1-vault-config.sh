#!/bin/bash

# configure vault to authorize demo3 service account
# use permissions described in demo3-policy.hcl

cd /vagrant/scripts/demo3

. ../functions.sh

CMD_ARRAY=(
"vault policy write demo3 demo3-policy.hcl"
"vimcat demo3-policy.hcl"
"vault write auth/kubernetes/role/demo3 bound_service_account_names=demo3 bound_service_account_namespaces=default policies=default,demo3 ttl=1h"
"vault policy write goldfish goldfish.hcl"
"vimcat goldfish.hcl"
"vault write auth/approle/role/goldfish  @goldfish-role.json"
"vimcat goldfish-role.json"
"vault write pki/roles/goldfish-tls allow_ip_sans=true allowed_domains=goldfish allow_bare_domains=true"
)

execute_array $CMD_ARRAY


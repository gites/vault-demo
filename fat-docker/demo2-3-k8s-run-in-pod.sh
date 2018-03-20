#!/bin/bash

# run in pod examples

cd /vagrant/scripts/demo2/
. ../functions.sh

export JWT=`cat /run/secrets/kubernetes.io/serviceaccount/token`

CMD_ARRAY=(
"cat /run/secrets/kubernetes.io/serviceaccount/token"
"vault write auth/kubernetes/login jwt=$JWT role=demo2 | tee /tmp/token"
"awk 'NR==3 { print \$2 }' /tmp/token | vault login - "
"echo Examples"
"vimcat demo2-policy.hcl"
"vault list secret"
"vault list secret/demoX/"
"vault read secret/demoX/cant_read_this"
"vault list secret/demo2/"
"vault read secret/demo2/secret1"
"vault read secret/demo2/secret2"
"vault read secret/demo2/write1"
"vault write secret/demo2/secret2 value=woop-woop"
"vault write secret/demo2/write1 value=woop-woop"
"vault delete secret/demo2/write1"
"vault read secret/demo2/delete-me1"
"vault delete secret/demo2/delete-me1"
"vault list secret/demo2/"
)

execute_array $CMD_ARRAY


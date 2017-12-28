#!/bin/bash

# run in pod examples

. /vagrant/scripts/functions.sh

CA_CERT="--cacert ${VAULT_CACERT}"

JWT=`cat /run/secrets/kubernetes.io/serviceaccount/token`

HTTP_BASE_CMD="http --verbose --json  --verify $VAULT_CACERT"

$HTTP_BASE_CMD POST ${VAULT_ADDR}/v1/auth/kubernetes/login  jwt=$JWT role=demo2
echo -n "TOKEN (from .auth.client_token)> "
read VAULT_TOKEN
$HTTP_BASE_CMD POST ${VAULT_ADDR}/v1/pki/issue/goldfish-tls X-Vault-Token:$VAULT_TOKEN common_name=goldfish ip_sans=1.1.1.11
pause
$HTTP_BASE_CMD POST ${VAULT_ADDR}/v1/auth/approle/role/goldfish/role-id X-Vault-Token:$VAULT_TOKEN role_id=goldfish
pause
$HTTP_BASE_CMD POST ${VAULT_ADDR}/v1/transit/keys/goldfish X-Vault-Token:$VAULT_TOKEN
pause
$HTTP_BASE_CMD POST ${VAULT_ADDR}/v1/secret/goldfish/conf X-Vault-Token:$VAULT_TOKEN DefaultSecretPath=secret/ TransitBackend=transit UserTransitKey=usertransit ServerTransitKey=goldfish BulletinPath=secret/goldfish/msg/
pause
$HTTP_BASE_CMD POST ${VAULT_ADDR}/v1/auth/approle/role/goldfish/secret-id X-Vault-Wrap-TTL:3600 X-Vault-Token:$VAULT_TOKEN

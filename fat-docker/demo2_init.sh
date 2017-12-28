#!/bin/bash
#Entrypoint script that sets up Vault config required for Goldfish
#API calls were converted from:
#- https://github.com/Caiyeon/goldfish/blob/master/vagrant/policies/goldfish.hcl
#- https://github.com/Caiyeon/goldfish/wiki/Production-Deployment#1-prepare-vault-only-needs-to-be-done-once
#
#Based of https://github.com/Caiyeon/goldfish/blob/master/docker/entrypoint.sh

#Be verbose for demo
set -x

CA_CERT="--cacert ${VAULT_CACERT}"

JWT=`cat /run/secrets/kubernetes.io/serviceaccount/token`

VAULT_TOKEN=`curl -v ${CA_CERT} ${VAULT_ADDR}/v1/auth/kubernetes/login -d "{\"jwt\":\"$JWT\", \"role\":\"demo2\"}" | jq .auth.client_token | tr -d \"`

#One place for curl options
CURL_OPT="-v ${CA_CERT} -H X-Vault-Token:${VAULT_TOKEN}"

#TLS for goldfish
PKI_DATA=`curl ${CURL_OPT} ${VAULT_ADDR}/v1/pki/issue/goldfish-tls -d '{"common_name":"goldfish","ip_sans":"1.1.1.11"}' | jq .data`
echo $PKI_DATA | jq -r .certificate > /certs/cert_bundle.pem
echo $PKI_DATA | jq -r .issuing_ca>> /certs/cert_bundle.pem
echo $PKI_DATA | jq -r .private_key > /certs/key.pem

curl ${CURL_OPT} ${VAULT_ADDR}/v1/auth/approle/role/goldfish/role-id -d '{"role_id":"goldfish"}'

# initialize transit key. This is not strictly required but is proper procedure
curl ${CURL_OPT} -X POST ${VAULT_ADDR}/v1/transit/keys/goldfish

# production goldfish needs a generic secret endpoint to hot reload settings from. See Configuration page for details
curl ${CURL_OPT} ${VAULT_ADDR}/v1/secret/goldfish/conf -d '{"DefaultSecretPath":"secret/", "TransitBackend":"transit", "UserTransitKey":"usertransit", "ServerTransitKey":"goldfish", "BulletinPath":"secret/goldfish/msg/"}'

#Generate token to start Goldfish with
WRAPPED_TOKEN=`curl ${CURL_OPT} --header "X-Vault-Wrap-TTL: 3600" -X POST ${VAULT_ADDR}/v1/auth/approle/role/goldfish/secret-id | jq -r .wrap_info.token`

echo $WRAPPED_TOKEN > /secrets/wrapped_token

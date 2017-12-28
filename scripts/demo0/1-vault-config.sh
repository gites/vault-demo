#!/bin/bash

# configure vault to work with kubernetes plugin

cd /vagrant/scripts/demo0

. ../functions.sh

CMD_ARRAY=(
"vimcat /etc/vault/vault.hcl"
"#vault server -config=/etc/vault/vault.hcl &"
"#vault init -key-shares=5 -key-threshold=3"
"cat /root/vault-init.txt"
"vault status"
"vault unseal `awk '/Unseal Key 1:/  { print $4 } ' /root/vault-init.txt`"
"vault status"
"vault unseal `awk '/Unseal Key 3:/  { print $4 } ' /root/vault-init.txt`"
"vault unseal `awk '/Unseal Key 4:/  { print $4 } ' /root/vault-init.txt`"
"vault status"
"vault audit-enable file file_path=/var/log/vault_audit.log log_raw=true hmac_accessor=false"
"vault auth -methods"
"vault auth-enable approle"
"vault auth-enable kubernetes"
"vault write auth/kubernetes/config kubernetes_host=https://k8s:6443 kubernetes_ca_cert=@/etc/kubernetes/pki/ca.crt"
"vault auth -methods"
"vault mounts"
"vault mount transit"
"vault mount pki"
"cat /opt/pki/K8s+Vault_Demo_Root_CA.crt /opt/pki/K8s+Vault_Demo_Root_CA.key >  /tmp/ca_bundle.pem"
"vault write pki/config/ca pem_bundle=@/tmp/ca_bundle.pem"
"vault mounts"
)

execute_array $CMD_ARRAY


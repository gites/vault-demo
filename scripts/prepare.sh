#!/bin/bash


DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND

apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update && apt-get install -y kubelet kubeadm kubectl ebtables ethtool docker.io jq htop unzip httpie

cat <<HOSTS >> /etc/hosts
1.1.1.11 k8s
1.1.1.11 vault
HOSTS

# PKI
wget -q https://github.com/square/certstrap/releases/download/v1.1.1/certstrap-v1.1.1-linux-amd64 -O /usr/local/sbin/certstrap
chmod +x /usr/local/sbin/certstrap
# Create CA
mkdir /opt/pki
certstrap --depot-path "/opt/pki/" init  --passphrase "" --common-name "K8s+Vault Demo Root CA"
cp /opt/pki/K8s+Vault_Demo_Root_CA.crt /usr/local/share/ca-certificates/
update-ca-certificates
# Use CA in K8s
mkdir -p /etc/kubernetes/pki/
cp /opt/pki/K8s+Vault_Demo_Root_CA.crt /etc/kubernetes/pki/ca.crt
cp /opt/pki/K8s+Vault_Demo_Root_CA.key /etc/kubernetes/pki/ca.key
# Certs for vault
certstrap --depot-path "/opt/pki/" request-cert --passphrase "" --common-name "vault" -ip "1.1.1.11,127.0.0.1" -domain "vault"
certstrap --depot-path "/opt/pki/" sign "vault" --CA "K8s+Vault Demo Root CA"

kubeadm init --kubernetes-version=v1.9.0 --apiserver-advertise-address=1.1.1.11 --apiserver-cert-extra-sans=k8s,1.1.1.11

mkdir -p $HOME/.kube
ln -sf /etc/kubernetes/admin.conf $HOME/.kube/config

kubectl completion bash > /etc/profile.d/k8s-completion.sh
kubectl apply -f /vagrant/scripts/calico.yaml
kubectl taint nodes --all node-role.kubernetes.io/master-

# Install Vault
VAULT_VER="0.9.5"
wget -q https://releases.hashicorp.com/vault/$VAULT_VER/vault_${VAULT_VER}_linux_amd64.zip -O /tmp/vault.zip
unzip -o /tmp/vault.zip -d /usr/local/sbin

mkdir -p /etc/vault/tls /opt/vault/storage
cp /opt/pki/vault* /etc/vault/tls

cat <<VAULT_CFG >/etc/vault/vault.hcl
storage "file" {
  path = "/opt/vault/storage"
}

listener "tcp" {
  address     = ":8200"
  tls_cert_file = "/etc/vault/tls/vault.crt"
  tls_key_file  = "/etc/vault/tls/vault.key"
}
VAULT_CFG

# Run Vault
/usr/local/sbin/vault server -config=/etc/vault/vault.hcl >/var/log/vault.log 2>&1 &
sleep 5
/usr/local/sbin/vault init -key-shares=5 -key-threshold=3 >/root/vault-init.txt 2>/dev/null
sleep 1
# Unseal
vault operator unseal `awk '/Unseal Key 1:/  { print $4 } ' /root/vault-init.txt`
vault operator unseal `awk '/Unseal Key 2:/  { print $4 } ' /root/vault-init.txt`
vault operator unseal `awk '/Unseal Key 3:/  { print $4 } ' /root/vault-init.txt`
vault status
vault --autocomplete-install

awk '/Initial Root Token:/  { print $4 } ' /root/vault-init.txt > /root/.vault-token

# Example secrets
vault write secret/demo2/secret1  vaule="super secret for demo2"
vault write secret/demo2/secret2  vaule=" woop woop  (V) (°,,,°) (V)"
vault write secret/demo2/delete-me1  vaule="delete me"
vault write secret/demoX/msg vaule="something something dark sie"
vault write secret/demoX/cant_read_this vaule="http://fandom.wikia.com/careers/listing/697886"
vault write secret/goldfish/msg/msg1 @/vagrant/scripts/demo3/goldfish-msg.json

# Seal (for demo)
vault operator seal

# Pull docker images
docker pull gites/ubuntu1604-vault:latest
#docker pull mysql

# Other stuff
wget -q https://raw.githubusercontent.com/vim-scripts/vimcat/master/vimcat -O /usr/local/bin/vimcat
chmod +x /usr/local/bin/vimcat
cd /root && git clone https://github.com/b4b4r07/vim-hcl .vim

# PS1
echo 'export PS1="\033[32;1;0;33;5;226m\u@\h:\w \033[m"' >> /root/.bashrc

ln -s /vagrant/scripts/ /root/vagrant

path "auth/approle/role/goldfish/role-id" {
  capabilities = ["update"]
}
path "auth/approle/role/goldfish/secret-id" {
  capabilities = ["update"]
}
path "transit/keys/goldfish" {
  capabilities = ["create","update"]
}
path "secret/goldfish/conf" {
  capabilities = ["create","update"]
}
path "pki/issue/goldfish-tls" {
  capabilities = ["update"]
}

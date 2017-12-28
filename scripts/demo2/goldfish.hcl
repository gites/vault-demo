path "transit/encrypt/goldfish" {
  capabilities = ["read","update"]
}
path "transit/decrypt/goldfish" {
  capabilities = ["read","update"]
}
path "secret/goldfish/conf" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "secret/goldfish/msg" {
  capabilities = ["read", "list"]
}

path "secret/demo2/*" {
  capabilities = ["read","list"]
}
path "secret/demo2/write*" {
  capabilities = ["update","create"]
}
path "secret/demo2/del*" {
  capabilities = ["delete"]
}
path "secret/*" {
  capabilities = ["list"]
}

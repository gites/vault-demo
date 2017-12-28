path "secret/demo1/*" {
  capabilities = ["read","list"]
}
path "secret/demo1/write*" {
  capabilities = ["update","create"]
}
path "secret/demo1/del*" {
  capabilities = ["delete"]
}
path "secret/*" {
  capabilities = ["list"]
}

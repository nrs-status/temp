ui = true

storage "file" {
  path = "/vault/file"
}

listener "tcp" {
  address = "0.0.0.0:443"
  tls_disable = true
  #ENABLE THESE AGAIN WHEN YOU'VE SET UP NETWORK MONITORING TO UNDERSTAND WHY SOMETIMES DNS FAILS
  #tls_cert_file = "vault/config/ca_cert.pem"
  #tls_key_file = "vault/config/cert_private_key.pem"

}

#api_addr = "http://127.0.0.1:8200"
#cluster_addr = "https://127.0.0.1:8201" #unused in single node setting but still required

path "kv-v2/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

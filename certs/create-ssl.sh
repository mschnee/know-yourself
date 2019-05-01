#!/bin/bash
cat <<'EOF' >> local.know-yourself.com.csr.cnf
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
C=US
ST=California
L=Los Angeles
O=Bambee
OU=Development
emailAddress=tech@know-yourself.com
CN = local.know-yourself.com
EOF

cat <<'EOF' >> local.know-yourself.com.v3.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = local.know-yourself.com
DNS.3 = *.local.know-yourself.com
EOF

openssl genrsa -des3 -out self-signed-rootCA.key 2048
openssl req -x509 -new -nodes -key self-signed-rootCA.key -sha256 -days 1024 -out self-signed-rootCA.pem -config <( cat local.know-yourself.com.csr.cnf )

openssl req -new -sha256 -nodes -out local.know-yourself.com.csr -newkey rsa:2048 -keyout local.know-yourself.com.key -config <( cat local.know-yourself.com.csr.cnf )
openssl x509 -req -in local.know-yourself.com.csr -CA self-signed-rootCA.pem -CAkey self-signed-rootCA.key -CAcreateserial -out local.know-yourself.com.crt -days 500 -sha256 -extfile local.know-yourself.com.v3.ext

echo ''
echo 'Certificates created'
echo ''
echo 'You will need to copy the rootCA to your ca-certificate store'
echo 'sudo mkdir /usr/share/ca-certificates/extra'
echo 'sudo cp self-signed-rootCA.pem /usr/share/ca-certificates/extra/self-signed-rootCA.pem'
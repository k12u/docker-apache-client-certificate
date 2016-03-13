Docker image to test Apache SSL Client Certificate
==================================================

This Docker image is used to test the Kanboard plugin [SSL Client Certificate](https://github.com/kanboard/plugin-client-certificate).

Create SSL certificates
-----------------------

TLDR to create the SSL certificates:

```bash
# Generate self-signed certificate CA
openssl req -config ./openssl.cnf -newkey rsa:2048 -nodes \
-keyform PEM -keyout ca.key -x509 -days 3650 -extensions certauth -outform PEM -out ca.cer

# Generate private server key
openssl genrsa -out server.key 2048

# Generate CSR
# Use hostname for CommonName
openssl req -config ./openssl.cnf -new -key server.key -out server.req

# Issue server certificate
openssl x509 -req -in server.req -CA ca.cer -CAkey ca.key \
-set_serial 100 -extfile openssl.cnf -extensions server -days 365 -outform PEM -out server.cer

rm -f server.req
```

```bash
# Private key for client
openssl genrsa -out client.key 2048

# Generate client CSR
# Put the username as CommonName and the user email address
openssl req -config ./openssl.cnf -new -key client.key -out client.req

# Issue client certificate
openssl x509 -req -in client.req -CA ca.cer -CAkey ca.key \
-set_serial 101 -extfile openssl.cnf -extensions client -days 365 -outform PEM -out client.cer

# Export client certificate
openssl pkcs12 -export -inkey client.key -in client.cer -out client.p12

rm -f client.key client.cer client.req
```

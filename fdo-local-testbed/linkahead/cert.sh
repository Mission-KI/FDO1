#!/bin/bash

source .env
export KEYPW="$LINKAHEAD_CERTIFICATES_KEY_PASSWORD"
export DOIP_SERVICE_ID="${LINKAHEAD_DOIP_SERVICE_ID/\//\\/}"
export DNS_HOST_NAME=${LINKAHEAD_DNS_HOST_NAME}

mkdir -p cert
pushd cert

# create encrypted private key
openssl genrsa -aes256 -out key.pem -passout env:KEYPW 2048

# create self-signed x509 certificate
openssl req -new -x509 -key key.pem -out cert.pem -passin env:KEYPW -subj "/C=/ST=/L=/O=IndiScale GmbH/OU=FDO ONE/CN=$DOIP_SERVICE_ID" -days 365 -addext "subjectAltName = DNS:$DNS_HOST_NAME" -addext "certificatePolicies = 1.2.3.4"

# extract public key
openssl x509 -pubkey -noout < cert.pem > pubkey.pem

# put certificate into pkcs12 store
openssl pkcs12 -export -inkey key.pem -in cert.pem -out cert.pkcs12 -passin env:KEYPW -passout env:KEYPW

# convert pkcs12 store to java keystore
keytool -importkeystore -srckeystore cert.pkcs12 -srcstoretype PKCS12 -deststoretype pkcs12 -destkeystore keystore.jks -srcstorepass "${KEYPW}" -destkeypass "${KEYPW}" -deststorepass "${KEYPW}"

popd
if [ -n "$CERT_OWNER" ] ; then
    chown -R "$CERT_OWNER:$CERT_OWNER" cert
fi

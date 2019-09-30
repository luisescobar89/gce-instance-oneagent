#!/bin/sh

#add 3 commands here
#wget -O /tmp/Dynatrace-OneAgent-Linux-1.177.167.sh "https://[DYNATRACE_TENANT]/api/v1/deployment/installer/agent/unix/default/latest?Api-Token=[API_TOKEN]&arch=x86&flavor=default"
#wget https://ca.dynatrace.com/dt-root.cert.pem ; ( echo 'Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha-256"; boundary="--SIGNED-INSTALLER"'; echo ; echo ; echo '----SIGNED-INSTALLER' ; cat Dynatrace-OneAgent-Linux-1.177.167.sh ) | openssl cms -verify -CAfile dt-root.cert.pem > /dev/null
#/bin/sh /tmp/Dynatrace-OneAgent-Linux-1.177.167.sh APP_LOG_CONTENT_ACCESS=1 INFRA_ONLY=0
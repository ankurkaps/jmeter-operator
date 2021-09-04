#!/bin/bash
###########################################################################
# https://stackoverflow.com/questions/58313106/create-rs256-jwt-in-bash
###########################################################################
PEM=$( cat jmeter.private.pem )
ISSUER="jmeter" # Whatever your github app id is
SUBJECT="cb_generic_connector"

NOW=$( date +%s )
# Expiry NOW + Two hours
EXP=$((${NOW} + 7200))

HEADER_RAW='{"alg":"RS256"}'
HEADER=$( echo -n "${HEADER_RAW}" | openssl base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n' )
PAYLOAD_RAW='{"exp":'"${EXP}"',"sub":'"\"${SUBJECT}\""',"iss":'"\"${ISSUER}\""'}'

echo "Payload: $PAYLOAD_RAW"

PAYLOAD=$( echo -n "${PAYLOAD_RAW}" | openssl base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n' )
HEADER_PAYLOAD="${HEADER}"."${PAYLOAD}"
SIGNATURE=$( openssl dgst -sha256 -sign <(echo -n "${PEM}") <(echo -n "${HEADER_PAYLOAD}") | openssl base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n' )
JWT="${HEADER_PAYLOAD}"."${SIGNATURE}"
echo $JWT

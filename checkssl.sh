#!/bin/bash
# check certificate chain
# Relies on bash

# Input the domain, intermediate and root - if multiple intermediates they have to be
# ordered in sequence "intermediate1 --> intermediateN --> root"
cat "$@" | \
    # Insert a single "non-base64" char to split / get to the certificates
    sed '/BEGIN/i@' | \
    # reverse the order to get to the root cert first, etc
    tac | \
    # Read the certificates one by one
    while read -d"@" CERT
    do
        # Remember to reverse the certificate again
        C_CERT=$(echo "$CERT" | tac)
        # Grab the Common Name for the output
        CN=$(echo "$C_CERT" | openssl x509 -noout -subject | sed 's/^.*CN=//')
        if [ -z "$CERTS" ]
        then
            # The root certificate is only verified against itself
            RET=$(echo "${C_CERT}" | openssl verify -verbose -CApath /no-such-dir -x509_strict 2>&1)
        else
            # Verify subsequent certificates agains the root, then root/intermediate(s)
            RET=$(echo "${C_CERT}" | openssl verify -verbose -CAfile <(echo -e "$CERTS") -CApath /no-such-dir -x509_strict 2>&1)
        fi
        # Save certificates as we progress, to be used in CAfile
        CERTS="${CERTS}\n${C_CERT}"
        echo "$RET - CN $CN"
    done

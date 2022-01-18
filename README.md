# checkssl
## Run ok
```
# ./checkssl.sh my-domain.crt intermediate-and-root.crt
stdin: OK - CN Root
stdin: OK - CN Intermediate
stdin: OK - CN example.com
```

## Run wrong
```
# ./check-cert.sh my-domain-error.crt intermediate-and-root.crt
stdin: OK - Root
stdin: OK - Intermediate
stdin: C = ... CN = example.com, serialNumber = 000000000
error 20 at 0 depth lookup:unable to get local issuer certificate - CN example.com/serialNumber=000000000
```

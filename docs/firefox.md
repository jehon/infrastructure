
## Certificates

https://github.com/mozilla/policy-templates/blob/master/README.md#Certificates

Binary (DER) and ASCII (PEM) certificates are both supported.

Check: about:policies

### Not used: openssl x509 -outform der -in Destop/exported_certificate/cert.pem -out synology-com.crt

# From Synology

- Go to Control Panel => Security => Certificate

Generate a new one, export it, take the "cert.pem" and put it in /usr/share/jehon/nas.pem (see policies.json)

## Override

Override is in profile (.mozilla/firefox/xxx/cert_override.txt or something like that)
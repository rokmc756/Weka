# https://www.notion.so/wekaio/Workaround-Custom-Certificate-Authorities-for-TLS-SSL-connections-from-WEKA-containers-42f88234379244c6b9d970ab45e9c0b4?pvs=4

dnf -y install jq

cp -f /opt/weka/dist/release/4.2.7.64.spec /opt/weka/dist/release/4.2.7.64.spec.orig

jq --arg SSL_CERT_FILE /host/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem '.containers.weka.env = $ARGS.named + .containers.weka.env' /opt/weka/dist/release/4.2.7.64.spec.orig > /opt/weka/dist/release/4.2.7.64.spec

grep SSL /opt/weka/dist/release/4.2.7.64.spec

weka user login admin Changeme12\!\@

weka status
weka local restart

cp /etc/wekaio/cacert.pem /etc/wekaio/cacert.pem.orig
cat /etc/pki/tls/certs/ca-bundle.crt >> /etc/wekaio/cacert.pem
mount -t wekafs | wc -l # should be zero
systemctl restart weka-agent.service

weka cloud disable && sleep 60 && weka cloud enable

# Confirm that recent events are displayed.  It may take several minutes for events to be made available.
weka events --start-time -5m

# If the SSL cert needed to be put into place due to OBS connectivity issues, check the connections.
weka fs tier s3

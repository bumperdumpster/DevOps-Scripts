#!/bin/sh
set -e
umask 077

IMAGE=$1
if [ "$IMAGE" = "" ]; then
    IMAGE=rancher/enterprise:v$RANCHER_VERSION
fi

echo Creating /var/lib/rancher/bin/rancher-ha-start.sh
cat > /var/lib/rancher/bin/rancher-ha-start.sh << "EOF"
#!/bin/sh
set -e

IMAGE=$1
if [ "$IMAGE" = "" ]; then
    echo Usage: $0 DOCKER_IMAGE
    exit 1
fi

docker rm -fv rancher-ha >/dev/null 2>&1 || true
ID=`docker run -d --restart=unless-stopped -p 8080:8080 -p 9345:9345 --name rancher-ha $IMAGE --db-host $DB_HOST --db-port $DB_PORT --db-user $DB_USER --db-pass "$DB_PASS" --db-name $DB_NAME --advertise-address $(hostname -i)`

echo Started container rancher-ha $ID
echo Run the below to see the logs
echo
echo docker logs -f rancher-ha
EOF

chmod +x /var/lib/rancher/bin/rancher-ha-start.sh

echo Running: /var/lib/rancher/bin/rancher-ha-start.sh $IMAGE
echo To re-run please execute: /var/lib/rancher/bin/rancher-ha-start.sh $IMAGE
exec /var/lib/rancher/bin/rancher-ha-start.sh $IMAGE
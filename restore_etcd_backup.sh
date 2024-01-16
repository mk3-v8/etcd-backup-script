

#!/bin/bash

RESTORE_FILE=$1
BACKUP_DIR="/var/lib/etcd/k8s_etcd_backup"
ETCD_DATA_DIR="/var/lib/etcd"
NEW_ETCD_DATA_DIR="/var/lib/etcd_restore"
ETCD_ENDPOINTS="https://127.0.0.1:2379"
CA_CERT="/etc/ssl/etcd/ssl/ca.pem"
SHORT_HOSTNAME=$(hostname | cut -d'.' -f1)
CERT="/etc/ssl/etcd/ssl/member-xxxxxxxxx.pem"
KEY="/etc/ssl/etcd/ssl/member-xxxxxxxxx-key.pem"
CERT_MODIFIED=$(echo "$CERT" | sed "s/xxxxxxxxx/$SHORT_HOSTNAME/")
KEY_MODIFIED=$(echo "$KEY" | sed "s/xxxxxxxxx/$SHORT_HOSTNAME/")
if [ -z "$RESTORE_FILE" ]; then
    echo "Usage: $0 <backup-file-name>"
    exit 1
fi
FULL_RESTORE_FILE="$BACKUP_DIR/$RESTORE_FILE"
if [ ! -f "$FULL_RESTORE_FILE" ]; then
    echo "Backup file not found: $FULL_RESTORE_FILE"
    exit 1
fi

systemctl stop etcd

UNCOMPRESSED_FILE="${FULL_RESTORE_FILE%.gz}"
if [ -f "$UNCOMPRESSED_FILE" ]; then
    echo "Uncompressed file already exists: $UNCOMPRESSED_FILE"
    rm -f "$UNCOMPRESSED_FILE"
fi

gzip -dk "$FULL_RESTORE_FILE"


if [ -d "$NEW_ETCD_DATA_DIR" ]; then
    mv "$NEW_ETCD_DATA_DIR" "${NEW_ETCD_DATA_DIR}_$(date +%Y%m%d%H%M%S)"
fi
mkdir -p "$NEW_ETCD_DATA_DIR"


ETCDCTL_API=3 etcdctl snapshot restore "$UNCOMPRESSED_FILE" \
  --endpoints=$ETCD_ENDPOINTS \
  --cacert=$CA_CERT \
  --cert=$CERT_MODIFIED \
  --key=$KEY_MODIFIED \
  --data-dir="$NEW_ETCD_DATA_DIR"

systemctl start etcd
rm -f "$UNCOMPRESSED_FILE"
echo "Backup restored successfully from $FULL_RESTORE_FILE"


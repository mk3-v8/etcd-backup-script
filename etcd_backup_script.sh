
#!/bin/bash


RETENTION_DAYS=14 # How many days to keep the backups.
CRON_SCHEDULE="0 2 * * *"  # Example: Run at 02:00 every day.
BACKUP_DIR="/var/lib/etcd/k8s_etcd_backup"
ETCD_ENDPOINTS="https://127.0.0.1:2379"
CA_CERT="/etc/ssl/etcd/ssl/ca.pem"
SHORT_HOSTNAME=$(hostname)
CERT="/etc/ssl/etcd/ssl/member-xxxxxxxxx.dev.local.pem"
KEY="/etc/ssl/etcd/ssl/member-xxxxxxxxx.dev.local-key.pem"
CERT_MODIFIED=$(echo "$CERT" | sed "s/xxxxxxxxx/$SHORT_HOSTNAME/")
KEY_MODIFIED=$(echo "$KEY" | sed "s/xxxxxxxxx/$SHORT_HOSTNAME/")
SCRIPT_PATH="$(realpath "$0")"
CRON_JOB="$CRON_SCHEDULE /bin/bash $SCRIPT_PATH"

if ! crontab -l | grep -q "$SCRIPT_PATH"; then
  (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
  echo "Cronjob added: $CRON_JOB"
fi

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Creating directory $BACKUP_DIR."
    mkdir -p "$BACKUP_DIR"
fi

BACKUP_FILE="$BACKUP_DIR/etcd-backup-$(date +%Y-%m-%d_%I:%M%p).db"

ETCDCTL_API=3 /usr/local/bin/etcdctl snapshot save $BACKUP_FILE \
  --endpoints=$ETCD_ENDPOINTS \
  --cacert=$CA_CERT \
  --cert=$CERT_MODIFIED \
  --key=$KEY_MODIFIED

gzip $BACKUP_FILE
find $BACKUP_DIR -name "etcd-backup-*.db.gz" -type f -mtime +$RETENTION_DAYS -delete

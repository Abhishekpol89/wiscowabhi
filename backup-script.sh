#!/bin/bash

# ---------- USER SETTINGS ----------
INSTANCE_ID="i-0123456789abcdef0"   # Replace with your EC2 instance ID
REMOTE_USER="ubuntu"                # Default EC2 username
REMOTE_DIR="/home/ubuntu/backup"    # Backup folder on EC2
SOURCE_DIR="/home/ubuntu/mydata"    # Local folder to back up
LOG_FILE="/home/ubuntu/backup_report.log"
# -----------------------------------

# 1. Fetch current EC2 public IP dynamically
REMOTE_HOST=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

# Check if IP was fetched
if [ -z "$REMOTE_HOST" ] || [ "$REMOTE_HOST" == "None" ]; then
    echo "❌ Could not fetch EC2 Public IP. Instance may be stopped."
    exit 1
fi

echo "🔗 Using EC2 Public IP: $REMOTE_HOST"

# 2. Create timestamp for unique backup
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="backup_$TIMESTAMP"

echo "=== Backup started at $TIMESTAMP ===" >> "$LOG_FILE"

# 3. Create remote backup directory
ssh -o StrictHostKeyChecking=no $REMOTE_USER@$REMOTE_HOST "mkdir -p $REMOTE_DIR/$BACKUP_NAME"

# 4. Copy files using scp
if scp -r "$SOURCE_DIR"/* $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/$BACKUP_NAME/; then
    echo "✅ Backup SUCCESS: $SOURCE_DIR -> $REMOTE_HOST:$REMOTE_DIR/$BACKUP_NAME" >> "$LOG_FILE"
else
    echo "❌ Backup FAILED: $SOURCE_DIR -> $REMOTE_HOST:$REMOTE_DIR/$BACKUP_NAME" >> "$LOG_FILE"
fi

echo "=== Backup finished ===" >> "$LOG_FILE"
echo "🎉 Backup complete. Check $LOG_FILE for details."


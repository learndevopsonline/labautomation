#!/bin/bash

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

DISK_SIZE=$(lsblk -bdno SIZE /dev/nvme0n1 2>/dev/null || lsblk -bdno SIZE /dev/sda 2>/dev/null)
DISK_GB=$((DISK_SIZE / 1073741824))
if [[ $DISK_GB -lt 50 ]]; then
   echo "ERROR: Disk size is ${DISK_GB}GB. Minimum 50GB required for Artifactory."
   exit 1
fi
echo "Disk size check passed: ${DISK_GB}GB"

echo "Installing Java 21 (Required for Artifactory 7.x)..."
dnf install -y java-21-openjdk-devel

growpart /dev/nvme0n1 4
pvresize /dev/nvme0n1p4
lvextend -r -L +10G /dev/RootVG/rootVol
lvextend -r -L +5G /dev/RootVG/varVol

echo "Configuring JFrog RPM Repository..."
# Download and move the repo file
curl -o /etc/yum.repos.d/jfrog-artifactory-rpms.repo -L https://releases.jfrog.io/artifactory/artifactory-rpms/artifactory-rpms.repo

echo "Installing Artifactory OSS..."
dnf install -y jfrog-artifactory-oss

echo "Step 4: Configuring System for Embedded Derby..."
# Define variables for paths
SYSTEM_YAML="/opt/jfrog/artifactory/var/etc/system.yaml"

# Backup default config
cp $SYSTEM_YAML ${SYSTEM_YAML}.bak

# Overwrite system.yaml with Derby configuration + disable JFConnect (causes 403 on OSS)
cat <<EOF > $SYSTEM_YAML
configVersion: 1
shared:
  database:
    type: derby
    allowNonPostgresql: true
jfconnect:
  enabled: false
EOF

# Ensure proper ownership
chown artifactory:artifactory $SYSTEM_YAML

echo "Starting and enabling Artifactory service..."
systemctl daemon-reload
systemctl enable artifactory.service
systemctl start artifactory.service

# Wait for service to fully initialize (Artifactory needs ~2 minutes)
echo "Waiting for Artifactory to start (this may take 2-3 minutes)..."
for i in $(seq 1 30); do
  if curl -sf http://localhost:8082/router/api/v1/system/health &>/dev/null; then
    echo "Artifactory is healthy!"
    break
  fi
  echo "Waiting... ($((i*10))s)"
  sleep 10
done

echo "Checking service status..."
systemctl status artifactory.service --no-pager

echo "------------------------------------------------------------"
echo "Installation Complete!"
echo "Access Artifactory at: http://$(curl ifconfig.me):8082/ui/"
echo "Default Credentials: admin / password"
echo "Remember to change the default password immediately."
echo "------------------------------------------------------------"

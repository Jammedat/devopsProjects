#!/bin/bash

# Install Memcached
sudo dnf install memcached -y

# Configure to listen on all interfaces (two methods for redundancy)
sudo sed -i 's/^-l.*/-l 0.0.0.0/' /etc/sysconfig/memcached

# Create systemd override (more reliable than config file)
sudo mkdir -p /etc/systemd/system/memcached.service.d
sudo tee /etc/systemd/system/memcached.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/memcached -p 11211 -u memcached -l 0.0.0.0 -m 64 -c 1024
EOF

# Configure firewall
sudo firewall-cmd --add-port=11211/tcp --permanent
sudo firewall-cmd --reload

# Apply changes
sudo systemctl daemon-reload
sudo systemctl restart memcached
sudo systemctl enable memcached

#!/bin/bash
# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# Update system and install dependencies
apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get install -y curl mingw-w64 binutils-mingw-w64 g++-mingw-w64

# Metasploit install
echo "Installing Metasploit Framework..."
# MSF nightly framework installer
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
chmod +x msfinstall
./msfinstall

# Sliver install
echo "Installing Sliver C2..."
mkdir -p /opt/sliver
cd /opt/sliver

# Install Sliver
curl https://sliver.sh/install -o sliverc2.sh
chmod +x sliverc2.sh
./sliverc2.sh

# Setup Sliver service
cat > /etc/systemd/system/sliver.service << 'EOL'
[Unit]
Description=Sliver C2 Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/sliver
ExecStart=/usr/local/bin/sliver-server daemon
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOL

# Enable and start Sliver service
systemctl daemon-reload
systemctl enable sliver
systemctl start sliver

# Verify service status
systemctl status sliver --no-pager
exit
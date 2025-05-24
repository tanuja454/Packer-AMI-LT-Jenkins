#!/bin/bash
set -e

echo "$(date) - Installing pre-requisites"

# Run as root (sudo) - to avoid permission denied errors
sudo apt-get update -y
sudo apt-get install -y curl build-essential

# Install Node.js 18.x and npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install pm2 globally
sudo npm install -g pm2

# Copy application files (already copied by Packer to /tmp/node-app)
mkdir -p /opt/node-app
sudo cp -r /tmp/node-app/. /opt/node-app/

# Install node app dependencies (production only)
cd /opt/node-app
sudo npm install --production

# Start the app with PM2 and enable PM2 to startup on boot for ubuntu user
sudo pm2 start ecosystem.config.js
sudo pm2 startup systemd -u ubuntu --hp /home/ubuntu
sudo pm2 save

echo "$(date) - Application setup complete"

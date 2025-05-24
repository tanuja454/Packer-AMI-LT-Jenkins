#!/bin/bash
set -e

echo "Installing pre-requisites"

# Setup Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash -
sudo apt-get update
sudo apt-get install -y nodejs build-essential

# Install PM2 globally
sudo npm install -g pm2

# Copy application files
sudo mkdir -p /opt/node-app
sudo cp -r /tmp/node-app/. /opt/node-app/
sudo chown -R ubuntu:ubuntu /opt/node-app

# Install dependencies and run with PM2
cd /opt/node-app
npm install --production

pm2 start ecosystem.config.js
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

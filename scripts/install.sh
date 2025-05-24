#!/bin/bash
set -euo pipefail

echo "Checking current apt sources:"
cat /etc/apt/sources.list || true

echo "Updating apt cache..."
sudo apt-get update -y

echo "Upgrading packages..."
sudo apt-get upgrade -y

echo "Installing curl and build-essential..."
sudo apt-get install -y curl build-essential

echo "Setting up Node.js 18.x repository..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

echo "Installing Node.js and npm..."
sudo apt-get install -y nodejs

echo "Installing PM2 globally..."
sudo npm install -g pm2

echo "Copying app files to /opt/node-app..."
sudo mkdir -p /opt/node-app
sudo cp -r /tmp/node-app/. /opt/node-app

echo "Installing app dependencies..."
cd /opt/node-app
sudo npm install --production

echo "Starting app with PM2..."
sudo pm2 start ecosystem.config.js

echo "Configuring PM2 startup on boot..."
sudo pm2 startup systemd -u ubuntu --hp /home/ubuntu
sudo pm2 save

echo "Installation and setup complete."

#!/bin/bash
set -e

# Update & install Node.js 18.x, npm, and PM2
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get update
sudo apt-get install -y nodejs build-essential

sudo npm install -g pm2

# Copy application files
sudo mkdir -p /opt/node-app
sudo cp -r /tmp/node-app/* /opt/node-app/

# Set correct ownership
sudo chown -R ubuntu:ubuntu /opt/node-app

# Install app dependencies
cd /opt/node-app
npm install --production

# Start the app with PM2 and enable PM2 startup on boot
pm2 start ecosystem.config.js
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

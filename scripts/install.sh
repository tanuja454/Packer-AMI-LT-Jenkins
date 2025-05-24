#!/bin/bash
set -e

# Install Node.js and dependencies
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get update
apt-get install -y nodejs build-essential

npm install -g pm2

# Create app directory
mkdir -p /opt/node-app

# Copy files (FIXED)
cp -r /tmp/node-app/. /opt/node-app/

# Install app dependencies
cd /opt/node-app
npm install --production

# Start with PM2
pm2 start ecosystem.config.js
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

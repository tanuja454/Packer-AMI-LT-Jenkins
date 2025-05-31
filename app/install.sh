#!/bin/bash
set -e

# Update and install Node.js + npm
sudo apt update -y
sudo apt install -y nodejs npm

# Install PM2 globally
sudo npm install -g pm2

# Go to app directory
cd /tmp/node-app

# Install Node app dependencies
npm install

# Start app using PM2
pm2 start ecosystem.config.js
pm2 save

# Make PM2 auto-start on boot (for ubuntu user)
pm2 startup systemd -u ubuntu --hp /home/ubuntu

#!/usr/bin/env bash

# Update package list and install Nginx
apt-get update -y
apt-get install -y nginx

# Copy the Nginx configuration file
cp /vagrant/lb/nginx.conf /etc/nginx/sites-available/load_balancer

# Enable the new Nginx configuration
ln -s /etc/nginx/sites-available/load_balancer /etc/nginx/sites-enabled/

# Remove the default Nginx configuration
rm /etc/nginx/sites-enabled/default

# Reload Nginx to apply the changes
systemctl reload nginx

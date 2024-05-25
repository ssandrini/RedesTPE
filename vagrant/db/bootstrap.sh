#!/bin/bash

apt-get update -y
# apt-get upgrade -y

echo 'Installing postgreSQL...'
apt-get install postgresql postgresql-contrib -y

echo 'Creating database users'
sudo -su postgres psql -f /vagrant/db/init.sql

PG_VERSION=14

# Update postgresql.conf to listen on all IP addresses
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/$PG_VERSION/main/postgresql.conf

# Append to pg_hba.conf to allow all IP addresses to connect
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/$PG_VERSION/main/pg_hba.conf

# Restart PostgreSQL to apply changes
sudo systemctl restart postgresql

# Open PostgreSQL port in firewall
sudo ufw allow 5432/tcp

# Reload PostgreSQL configuration
sudo systemctl reload postgresql

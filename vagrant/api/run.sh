#!/bin/bash

echo 'Running api on port 80'
echo 'Logs at ~/api.log'
sudo python3 /vagrant/api/src/main.py >> api.log &

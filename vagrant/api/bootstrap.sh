#!/bin/bash

apt-get update -y
# apt-get upgrade -y

apt-get install python3 -y
apt-get install python3-pip -y

echo 'Installing python dependencies...'
pip3 install uvicorn fastapi sqlalchemy psycopg2-binary

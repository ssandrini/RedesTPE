-- Create database
CREATE DATABASE api;

-- Create user
CREATE USER api_user WITH PASSWORD 'api_password';

-- Grant privileges to the user on the database
GRANT ALL PRIVILEGES ON DATABASE api TO api_user;

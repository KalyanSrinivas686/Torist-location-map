#!/bin/bash

# Stop execution if any command fails
set -e

echo "Waiting for MySQL database..."

# Loop and wait until the 'db' host is listening on port 3306
# We use a small python snippet so we don't need to install extra tools like netcat
python -c "
import socket
import time
import os

host = 'db'
port = 3306
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
while True:
    try:
        s.connect((host, port))
        s.close()
        break
    except socket.error:
        print('Waiting for database...')
        time.sleep(1)
"

echo "MySQL is up - executing command"

# Run database migrations automatically
echo "Applying database migrations..."
python manage.py migrate

# Start the main process (the command from docker-compose)
exec "$@"

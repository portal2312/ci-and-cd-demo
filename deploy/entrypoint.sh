#!/bin/bash
set -ex

echo "Starting SSH daemon..."
sudo /usr/sbin/sshd

if [ ! -d /var/lib/pgsql/15/data/base ]; then
  echo
  echo "Initializing PostgreSQL..."
  sudo -u postgres /usr/pgsql-15/bin/initdb -D /var/lib/pgsql/15/data
fi
echo "Starting PostgreSQL..."
sudo -u postgres /usr/pgsql-15/bin/pg_ctl -D /var/lib/pgsql/15/data start

echo
echo "Starting Nginx..."
sudo nginx -c /etc/nginx/nginx.conf

echo
echo "ok."

#!/bin/bash
set -e

# Check environment variables
if [[ -z "$NEXUS_HOST" || -z "$NEXUS_USER" || -z "$NEXUS_PASSWORD" || -z "$NEXUS_REPO" ]]; then
  echo "Required environment variables (NEXUS_HOST, NEXUS_USER, NEXUS_PASSWORD, NEXUS_REPO) are missing."
  exit 1
fi

CLIENT_TAR="client-dist.tar"
SERVER_TAR="server.tar"
DEPLOY_TAR="deploy.tar"

# Downloads artifacts from Nexus repository
curl -u "${NEXUS_USER}:${NEXUS_PASSWORD}" -o /app/${CLIENT_TAR} "${NEXUS_HOST}/repository/${NEXUS_REPO}/${CLIENT_TAR}"
curl -u "${NEXUS_USER}:${NEXUS_PASSWORD}" -o /app/${SERVER_TAR} "${NEXUS_HOST}/repository/${NEXUS_REPO}/${SERVER_TAR}"
curl -u "${NEXUS_USER}:${NEXUS_PASSWORD}" -o /app/${DEPLOY_TAR} "${NEXUS_HOST}/repository/${NEXUS_REPO}/${DEPLOY_TAR}"

# Move artifacts to the appropriate directories
mkdir -p /app/client/dist /app/server
tar -xvf /app/${CLIENT_TAR} -C /app/client/dist && rm /app/${CLIENT_TAR}
tar -xvf /app/${SERVER_TAR} -C /app/server && rm /app/${SERVER_TAR}
tar -xvf /app/${DEPLOY_TAR} -C /app/ && rm /app/${DEPLOY_TAR}

# Set up Nginx configuration
# cp -rvp /app/nginx.conf /etc/nginx/nginx.conf

# Start PostgreSQL
# sudo -u postgres /usr/pgsql-15/bin/initdb -D /var/lib/pgsql/15/data
# sudo -u postgres /usr/pgsql-15/bin/pg_ctl -D /var/lib/pgsql/15/data start

# Install and Upgrade dependencies for the server
python -m pip install -r /app/server/requirements.txt

# Start the server
# python -m gunicorn --config /app/gunicorn.conf.py project.asgi:application

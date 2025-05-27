#!/bin/bash
set -ex

# Check environment variables
if [[ -z "$NEXUS_URL" || -z "$NEXUS_USER" || -z "$NEXUS_PASSWORD" || -z "$NEXUS_REPO" ]]; then
  echo "Required environment variables (NEXUS_URL, NEXUS_USER, NEXUS_PASSWORD, NEXUS_REPO) are missing."
  exit 1
fi

CLIENT_TAR="client-dist.tar"
SERVER_TAR="server.tar"
DEPLOY_TAR="deploy.tar"

echo
echo "Downloading artifacts from Nexus repository..."
curl -u "${NEXUS_USER}:${NEXUS_PASSWORD}" -o /app/${CLIENT_TAR} "${NEXUS_URL}/repository/${NEXUS_REPO}/${CLIENT_TAR}"
curl -u "${NEXUS_USER}:${NEXUS_PASSWORD}" -o /app/${SERVER_TAR} "${NEXUS_URL}/repository/${NEXUS_REPO}/${SERVER_TAR}"
curl -u "${NEXUS_USER}:${NEXUS_PASSWORD}" -o /app/${DEPLOY_TAR} "${NEXUS_URL}/repository/${NEXUS_REPO}/${DEPLOY_TAR}"

echo
echo "Extracting artifacts..."
mkdir -p /app/client/dist /app/server
tar -xvf /app/${CLIENT_TAR} -C /app/client/dist && rm /app/${CLIENT_TAR}
tar -xvf /app/${SERVER_TAR} -C /app/server && rm /app/${SERVER_TAR}
tar -xvf /app/${DEPLOY_TAR} -C /app/ && rm /app/${DEPLOY_TAR}

echo
echo "Setting up Nginx configuration..."
sudo cp -rvp /app/nginx.conf /etc/nginx/nginx.conf


echo
if pgrep -x "nginx" > /dev/null; then
  echo "Reloading Nginx..."
  sudo nginx -c /etc/nginx/nginx.conf -s reload
else
  echo "Starting Nginx..."
  sudo nginx -c /etc/nginx/nginx.conf
fi

echo
echo "Installing dependencies for the server..."
python -m pip install --upgrade pip
python -m pip install -r /app/server/requirements.txt

echo
echo "Running migrations for the server..."
python /app/server/manage.py migrate --pythonpath=/app/server

echo
if pgrep -f "gunicorn" > /dev/null; then
  echo "Stopping existing Gunicorn process..."
  pkill -f "gunicorn"
  sleep 2
fi

echo
echo "Starting Gunicorn server..."
nohup python -m gunicorn --config=/app/gunicorn.conf.py project.asgi:application > /dev/null 2>&1 < /dev/null &
sleep 3

echo
if pgrep -f "gunicorn" > /dev/null; then
  echo "Gunicorn is running."
else
  echo "Gunicorn is NOT running."
  exit 1
fi

echo
echo "ok."

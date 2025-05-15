#!/bin/bash
set -e

# Check environment variables
if [[ -z "$NEXUS_HOST" || -z "$NEXUS_USER" || -z "$NEXUS_PASSWORD" || -z "$NEXUS_REPO" ]]; then
  echo "Required environment variables (NEXUS_HOST, NEXUS_USER, NEXUS_PASSWORD, NEXUS_REPO) are missing."
  exit 1
fi

CLIENT_TAR="client-dist.tar"
SERVER_TAR="server.tar"

# Downloads artifacts from Nexus repository
curl -u "${NEXUS_USER}:${NEXUS_PASSWORD}" -o /app/${CLIENT_TAR} "${NEXUS_HOST}/repository/${NEXUS_REPO}/${CLIENT_TAR}"
curl -u "${NEXUS_USER}:${NEXUS_PASSWORD}" -o /app/${SERVER_TAR} "${NEXUS_HOST}/repository/${NEXUS_REPO}/${SERVER_TAR}"

# Move artifacts to the appropriate directories
mkdir -p /app/client/dist /app/server
tar -xvf /app/${CLIENT_TAR} -C /app/client/dist && rm /app/${CLIENT_TAR}
tar -xvf /app/${SERVER_TAR} -C /app/server && rm /app/${SERVER_TAR}

# 4. 서비스 재시작 등 추가 작업
# systemctl restart my-server
# systemctl reload nginx

#!/bin/bash
set -e

CLIENT_TAR="client-dist.tar"
SERVER_TAR="server.tar"

# Downloads artifacts from Nexus repository
curl -u "${NEXUS_USER}:${NEXUS_PASSWORD}" -O "${NEXUS_HOST}/repository/${NEXUS_REPO}/${CLIENT_TAR}"
curl -u "${NEXUS_USER}:${NEXUS_PASSWORD}" -O "${NEXUS_HOST}/repository/${NEXUS_REPO}/${SERVER_TAR}"

# Move artifacts to the appropriate directories
mkdir -p /app/client/dist
tar -xvf /app/${CLIENT_TAR} -C /app/client/dist
mkdir -p /app/server
tar -xvf /app/${SERVER_TAR} -C /app/server

# 4. 서비스 재시작 등 추가 작업
# systemctl restart my-server
# systemctl reload nginx

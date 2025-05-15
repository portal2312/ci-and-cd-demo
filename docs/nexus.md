# Nexus

## Installation

Edit `docker-compose.yml`:

```yaml
name: ci-and-cd-demo

services:
  # ...exists services

  nexus:
    image: sonatype/nexus3
    container_name: nexus
    ports:
      - "8081:8081"
    volumes:
      - nexus-data:/nexus-data
    restart: unless-stopped

volumes:
  # ...exists volumes

  nexus-data:
```

Up docker compose:

```bash
docker compose -f "docker-compose.yml" up -d --build
```

Get initial admin password:

```bash
docker exec -it nexus cat /nexus-data/admin.password
# cf3af8f1-98c2-4bca-8c8f-86b2b9b9cf65
```

Go to `http://localhost:8081`.

## Blob Store 및 Hosted Repository 생성 (e.g., docker-hosted)

### Set up Blob Storage

1. Go to **⚙️ Repository** menu

2. Go to **Blob Stores** sub menu

3. click **Create Blob Store** button

4. Edit and save:

   - Type: `File`
   - Name: _ci-and-cd-demo_
   - Path: (auto-completion)

### Set up Repositories

1. Go to **⚙️ Repository** menu

2. Go to **Repositories** sub menu

3. Click **Create repository** and Click `raw (hosted)` item

4. Edit and click **Create repository**:

   - Name: _ci-and-cd-demo-artifacts_
   - Blob store: `ci-and-cd-demo`

5. Click created `ci-and-cd-demo-artifacts`

6. Show URL and Check `NEXUS_REPO` in URL:
   `ci-and-cd-demo-artifacts`

## Set up Port Forwarding

IP Time Port Forwarding. Refer to [this](./port_forwarding.md).

## Set up GitHub Actions

Edit `.github/workflows/ci.yml`:

```yml
name: ci-and-cd-demo-ci

on:
  push:
    branches:
      - main

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      # ...exists steps

      - name: Upload Docker image to Nexus
        run: |
          curl -v -u ${{ secrets.NEXUS_USER }}:${{ secrets.NEXUS_PASSWORD }} \
            --upload-file server/ci-and-cd-demo-app.tar \
            ${{ secrets.NEXUS_HOST }}/repository/${{ secrets.NEXUS_REPO }}/ci-and-cd-demo-app.tar
```

## Etc

파일(컴포넌트) 목록 조회:

```bash
curl -u ${NEXUS_USER}:${NEXUS_PASSWORD} ${NEXUS_HOST}/service/rest/v1/components?repository=${NEXUS_REPO}
```

파일(컴포넌트) 삭제:

```bash
curl -u ${NEXUS_USER}:${NEXUS_PASSWORD} -X DELETE ${NEXUS_HOST}/service/rest/v1/components/${COMPONENT_ID}
```

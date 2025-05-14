# Runner

## Set up

### Dockerfile

[actions-runner/Dockerfile](../actions-runner/Dockerfile)

### entrypoint.sh

[actions-runner/entrypoint.sh](../actions-runner/entrypoint.sh)

### docker-compose.yml

```yml
name: ci-and-cd-demo

services:
  # ...existing code...
  actions-runner:
    build:
      context: ./actions-runner
      dockerfile: Dockerfile
      args:
        RUNNER_VERSION: ${RUNNER_VERSION}
    tty: true
    stdin_open: true
    restart: unless-stopped
    volumes:
      - actions-runner-data:/actions-runner
    environment:
      - RUNNER_URL=${RUNNER_URL}
      - RUNNER_TOKEN=${RUNNER_TOKEN}
      - RUNNER_NAME=${RUNNER_NAME}
      - RUNNER_LABELS=${RUNNER_LABELS}
```

### .env

```ini
# ...existing code...

# Runner
RUNNER_VERSION=2.323.0
RUNNER_URL=https://github.com/portal2312/ci-and-cd-demo
RUNNER_TOKEN=ACRCVIXFYDGTPPUKJPEZLL3ICGECU
RUNNER_NAME=ci-and-cd-demo-runner
RUNNER_LABELS=ci-and-cd-demo-runner
```

- RUNNER_NAME: Runner 이름
- RUNNER_LABELS: (중요) 워크플로우 파일의 각 작업마다 `runs-one` 에서 참조 한다

> [!NOTE]
> Get RUNNER_VERSION, RUNNER_URL, RUNNER_TOKEN:
>
> 1. Go to **Your Repository**
> 2. Click **Settings** tab
> 3. Click **Code and automation/Actions/Runners** menu
> 4. Click **New self-hosted runner** button
>    - Runner image: `Linux`
>    - Architecture: `ARM64`
> 5. Show Configure panel.

### .github/workflows/ci.yml

### Start PostgreSQL by pg_ctl

### Start PostgreSQL by Docker

```bash
sudo -u postgres initdb -D /var/lib/pgsql/15/data
sudo -u postgres pg_ctl -D /var/lib/pgsql/15/data start
```

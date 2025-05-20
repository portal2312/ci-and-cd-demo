# GitHub Actions Self-hosted Runners

Spec:

- rockylinux:8
- non-root user
- Docker
- uv
- NVM
- Support non-interactive shell
- GitHub Self-hosted Runner

References:

- [Add self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners)

## Installation

### Dockerfile

Edit [actions-runner/Dockerfile](../actions-runner/Dockerfile).

### Docker Compose

Edit [docker-compose.yml](../docker-compose.yml).

```yml
name: ci-and-cd-demo

services:
  # ... exists services

  actions-runner:
    build:
      context: ./actions-runner
      args:
        # NOTE: RUNNER_VERSION 을 제어하기 위해
        RUNNER_VERSION: ${RUNNER_VERSION}
    tty: true
    stdin_open: true
    volumes:
      # NOTE: 설정과 생성 된 파일 보존을 위해
      - actions-runner-data:/actions-runner
      # NOTE: Local 에서 Docker 를 제어하기 위해
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - RUNNER_URL=${RUNNER_URL}
      - RUNNER_TOKEN=${RUNNER_TOKEN}
      - RUNNER_NAME=${RUNNER_NAME:-ci-and-cd-demo-runner}
      - RUNNER_LABELS=${RUNNER_LABELS:-ci-and-cd-demo-runner}
```

> [!NOTE]
> 해당 container 에서 실행되는 Docker 의 image 나 container 를 나의 로컬에서 제어하기 위해 `/var/run/docker.sock:/var/run/docker.sock` volume 을 정의합니다.

Set up [Environment variables](#environment-variables).

Up docker compose:

```bash
docker compose -f "docker-compose.yml" up -d --build
```

### Environment variables

`.env`:

```ini
# ...existing code...

# Runner
RUNNER_VERSION=2.323.0
RUNNER_URL=https://github.com/portal2312/ci-and-cd-demo
RUNNER_TOKEN=ACRCVIXFYDGTPPUKJPEZLL3ICGECU
RUNNER_NAME=ci-and-cd-demo-runner
RUNNER_LABELS=ci-and-cd-demo-runner
```

#### `RUNNER_NAME`

Runner name

#### `RUNNER_LABELS`

Runner labels

> [!IMPORTANT]
> 여기서 `RUNNER_LABELS` 는 `.github/workflows` 의 `*.yml` 에 각 작업마다 [`runs-on`](https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions#jobsjob_idruns-on) 에서 참조 한다.

#### `RUNNER_VERSION` and `RUNNER_URL` and `RUNNER_TOKEN`

1. Go to **Your Repository**
2. Click **Settings** tab
3. Click **Code and automation/Actions/Runners** menu
4. Click **New self-hosted runner** button
   - Runner image: `Linux`
   - Architecture: `ARM64`
5. Show Configure panel.

### `entrypoint.sh`

GitHub Actions self-hosted-runners 의 설정과 기동을 합니다.

[This file](../actions-runner/entrypoint.sh) is used last in the Dockerfile.

> [!NOTE]
> Generally, Docker does not use systemd.

> [!NOTE]
> Already, the `/var/jenkins_home` directory is docker compose global volume. Refer to [docker-compose.yml](../docker-compose.yml).

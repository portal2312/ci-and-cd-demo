# GitHub Actions Self-hosted Runner

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

### `Dockerfile`

Edit [`Dockerfile`](../../runner/Dockerfile).

### Set Environment variables

Edit [`.env`](../../.env):

```ini
# ...existing code...

# Runner
RUNNER_CHECKSUM=b5a5cf1138064afd0f0fb1a4a493adaa9bff5485ace3575e99547f004dbb20fa
RUNNER_LABELS=ci-and-cd-demo-runner
RUNNER_NAME=ci-and-cd-demo-runner
RUNNER_TOKEN=ACRCVIXFYDGTPPUKJPEZLL3ICGECU
RUNNER_URL=https://github.com/username/ci-and-cd-demo
RUNNER_VERSION=2.324.0
RUNNER_NODE_VERSION=v22.14.0
```

#### `RUNNER_CHECKSUM`

> [!NOTE]
> Add new self-hosted runner, then generate a checksum.

#### `RUNNER_LABELS`

Runner labels.

> [!IMPORTANT]
> GitHub workflows jobs 작업의 [`runs-on`](https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions#jobsjob_idruns-on) 에서 사용한다.

#### `RUNNER_NAME`

Runner name.

#### `RUNNER_TOKEN`

1. Go to **Your Repository**
2. Go to **Settings** menu
3. Click **Code and automation/Actions/Runners** right sub menu
4. Click **New self-hosted runner** button
   - Runner image: `Linux`
   - Architecture: `ARM64`
5. Show **Configure** panel.

> [!NOTE]
> Add new self-hosted runner, then generate a unique token.

#### `RUNNER_URL`

Runner HTTP protocol + host + port.

1. Go to **Your Repository**
2. Go to **Settings** menu
3. Click **Code and automation/Actions/Runners** right sub menu
4. Click **New self-hosted runner** button
   - Runner image: `Linux`
   - Architecture: `ARM64`
5. Show **Configure** panel.

#### `RUNNER_VERSION`

Runner version.

1. Go to **Your Repository**
2. Go to **Settings** menu
3. Click **Code and automation/Actions/Runners** right sub menu
4. Click **New self-hosted runner** button
   - Runner image: `Linux`
   - Architecture: `ARM64`
5. Show **Download** panel.

#### `RUNNER_NODE_VERSION`

Node version on the running `runner` container.

### Docker Compose

Add the `runner` service to your [`docker-compose.yml`](../../docker-compose.yml).

Up docker compose:

```bash
docker compose -f "docker-compose.yml" up -d --build
```

### `entrypoint.sh`

GitHub Actions self-hosted-runners configuration and run.

[This file](../runner/entrypoint.sh) is used last in the Dockerfile.

# Deploy

## Installation

### Dockerfile

Edit [`deploy/Dockerfile`](../deploy/Dockerfile).

### Docker Compose

Edit [`docker-compose.yml`](../docker-compose.yml):

```yml
name: ci-and-cd-demo

services:
  # ...exists services

  deploy:
    build:
      context: ./deploy
      args:
        - NEXUS_HOST=${NEXUS_HOST:-http://nexus:8081}
        - NEXUS_PASSWORD=${NEXUS_PASSWORD}
        - NEXUS_USER=${NEXUS_USER:-admin}
        - NEXUS_REPO=${NEXUS_REPO}
    tty: true
    stdin_open: true
    ports:
      - 80:80
      - 443:443
    volumes:
      # NOTE: SSH 설정 등 유지 한다
      - deploy_data:/home/appuser

volumes:
  # ...exists services

  deploy_data:
```

## Configuration

### Set Up SSH authorized keys for jenkins

Set up:

```bash
echo 'GENERATED_PUBLIC_SSH_KEY' >> ~/.ssh/authorized_keys
```

- `'GENERATED_PUBLIC_SSH_KEY'`: Public key of [Generated SSH keys](./jenkins-set-up-pipeline-ssh-command.md#set-up-ssh-keys)

> [!IMPORTANT]
> non-root user SSH files and directories permissions:
>
> - `~/.ssh`: `drwx------`(700), `appuser:appuser`
> - `~/.ssh/authorized_keys`: `-rw-------`(600), `appuser:appuser`

Test:

Go to **jenkins** container, and try SSH connect to **deploy** container:

```bash
ssh -i ~/.ssh/jenkins_deploy appuser@deploy
```

#### Using SSH to execute commands

Go to **jenkins** container, and try execute to `/app/deploy_from_nexus.sh` on **deploy** container:

```bash
ssh -i ~/.ssh/jenkins_deploy -o StrictHostKeyChecking=no appuser@deploy 'bash -l -c "/app/deploy_from_nexus.sh"'
```

## entrypoint.sh

서비스 실행을 위해 사용한다.

## deploy_from_nexus.sh

배포와 서비스 실행을 하는 파일이다.

이 파일은 [Jenkins 에 등록 된 특정 pipeline 의 설정](./jenkins-set-up-pipeline-ssh-command.md#set-up-pipeline)에서 [Jenkinsfile](../Jenkinsfile) 파일에 의해 실행 된다.

## Services

### WEB

### WAS

Start:

```bash
python -m gunicorn --config=/app/gunicorn.conf.py --pythonpath=/app/server project.asgi:application
```

- [`--config`](https://docs.gunicorn.org/en/stable/settings.html#config): [`gunicorn.conf.py`](../deploy/gunicorn.conf.py) gunicorn 설정 경로를 입력하기
- [`--pythonpath`](https://docs.gunicorn.org/en/stable/settings.html#pythonpath): 서비스의 최상위 경로를 입력하기

> [!NOTE]
> Production is [Gunicorn](https://docs.gunicorn.org/en/latest/deploy.html#deploying-gunicorn) + [Uvicorn](https://www.uvicorn.org/deployment/) + [uvicorn-worker](https://github.com/Kludex/uvicorn-worker)

### DB

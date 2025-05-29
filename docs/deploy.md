# Deploy

## Installation

### `Dockerfile`

Edit [`Dockerfile`](../../deploy/Dockerfile).

### Docker Compose

Add the `deploy` service to your [`docker-compose.yml`](../docker-compose.yml).

Up docker compose:

```bash
docker compose -f "docker-compose.yml" up -d --build
```

### `entrypoint.sh`

Execute the required services in Docker.

[This file](../deploy/entrypoint.sh) is used last in the Dockerfile.

> [!NOTE]
> Generally, Docker does not use systemd.

### `deploy_from_nexus.sh`

Patch sources and execute required services.

The [`deploy_from_nexus.sh`](../deploy/deploy_from_nexus.sh) is executed by [`Jenkinsfile`](../Jenkinsfile).

> [!NOTE]
> Initially, upload only this file.  
> Now, it automatically updates itself.

### `gunicorn.conf.py`

Gunicorn basic configuration file.

> [!TIP]
> Production is [Gunicorn](https://docs.gunicorn.org/en/latest/deploy.html#deploying-gunicorn) + [Uvicorn](https://www.uvicorn.org/deployment/) + [uvicorn-worker](https://github.com/Kludex/uvicorn-worker)

### `nginx.conf`

Nginx basic configuration file.

## Configuration

### Set up SSH authorized keys for jenkins

Add the [`~/.ssh/jenkins_deploy.pub`](./jenkins/pipeline-ssh-command.md#sshjenkins_deploypub) file from the `jenkins` container to the `~/.ssh/authorized_keys` file of the `appuser` user in the `deploy` container:

```bash
# The appuser shell in the deploy container
echo 'JENKINS_SSH_PUBLIC_KEY' >> ~/.ssh/authorized_keys
```

> [!IMPORTANT]
> The `deploy` container SSH files and directories permissions of `appuser` user:
>
> - `~/.ssh`: `drwx------`(700), `appuser:appuser`
> - `~/.ssh/authorized_keys`: `-rw-------`(600), `appuser:appuser`

> [!NOTE]
> Already, the `/home/appuser` directory is docker compose global volume. Refer to [`docker-compose.yml`](../docker-compose.yml).

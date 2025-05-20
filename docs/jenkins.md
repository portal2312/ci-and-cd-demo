# Jenkins

## Installation

### Dockerfile

Edit [`jenkins/Dockerfile`](../jenkins/Dockerfile).

### Docker Compose

Edit [`docker-compose.yml`](../docker-compose.yml):

```yml
name: ci-and-cd-demo

services:
  # ...exists services

  jenkins:
    build:
      context: ./jenkins
    ports:
      - 8080:8080
      - 50000:50000
    volumes:
      - jenkins_data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped

volumes:
  # ...exists volumes

  jenkins_data:
```

> [!NOTE]
> 여기서 `jenkins` container 에서 실행되는 Docker 의 image 나 container 를 나의 로컬에서 제어하기 위해 `/var/run/docker.sock:/var/run/docker.sock` volume 을 정의합니다.

Up docker compose:

```bash
docker compose -f "docker-compose.yml" up -d --build
```

Get initial admin password:

```bash
docker exec -it ci-and-cd-demo-jenkins-1 cat /var/jenkins_home/secrets/initialAdminPassword
# 9712ee6f95984320ac2695b70c460940
```

Go to [`http://localhost:8080`](http://localhost:8080).

Input to getting initial admin password.

## Configuration

### Set up Plugins

1. Go to **Dashboard**

2. Go to **Jenkins 관리**

3. Go to **Plugins**

4. Check plugins and install:

   - [x] Pipeline: Required

### Set up Credentials

1. Go to **Dashboard**

2. Go to **Jenkins 관리**

3. Go to **Credentials**

4. Click **(global)** at **Stores scoped to Jenkins** table **Domains** column

5. Click **Add Credentials** and **Save** for GitHub Personal Access Token Click:

   - Kind: `Username with password`
   - Username: _Your username for GitHub_
   - Password: _key for ci-and-cd-demo-personal-access-token_
   - ID: _ci-and-cd-demo-personal-access-token_

6. Click **Add Credentials** and **Save** for Nexus:

   - Kind: `Username with password`
   - Username: _Your username for Nexus_
   - Password: _Your password for Nexus_
   - ID: _ci-and-cd-demo-nexus-credentials_

## Set up Pipeline

- [Set up pipeline docker](./jenkins-set-up-pipeline-docker.md)
- [Set up pipeline ssh command](./jenkins-set-up-pipeline-ssh-command.md)

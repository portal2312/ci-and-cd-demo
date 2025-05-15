# Jenkins

## Installation

### Dockerfile

Edit [`jenkins/Dockerfile`](../jenkins/Dockerfile).

### Docker Compose

Edit `docker-compose.yml`:

```bash
name: ci-and-cd-demo

services:
  # ...exists services

  jenkins:
    build:
      context: ./jenkins
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
      - "50000:50000"
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
> 이것은 `jenkins` container 가 pipeline 설정에 의한 `server/Jenkinsfile` 스크립트를 실행 시, 나의 로컬안에서 Docker 의 image 나 container 가 생성됩니다.

Up docker compose:

```bash
docker compose -f "docker-compose.yml" up -d --build
```

Get initial admin password:

```bash
docker exec -it ci-and-cd-demo-jenkins-1 cat /var/jenkins_home/secrets/initialAdminPassword
# 9712ee6f95984320ac2695b70c460940
```

Go to `http://localhost:8080`.

Input to getting initial admin password.

Set up suggest plugins.

## Set up Plugins

1. Go to **Dashboard**

2. Go to **Jenkins 관리**

3. Go to **Plugins**

4. Check plugins and install:

   - [x] Pipeline: Required
   - [x] Docker Pipeline: Required
   - [x] Blue Ocean: Very useful

## Set up Pipeline

### Set up Credentials

1. Go to **Dashboard**

2. Go to **Jenkins 관리**

3. Go to **Credentials**

4. Click **(global)** at **Stores scoped to Jenkins** table **Domains** column

5. Click **Add Credentials** and **Save**:

   - Kind: `Username with password`
   - Username: _Your username for GitHub_
   - Password: _key for ci-and-cd-demo-personal-access-token_
   - ID: _ci-and-cd-demo-personal-access-token_

6. Click **Add Credentials** and **Save**:

   - Kind: `Username with password`
   - Username: _Your username for Nexus_
   - Password: _Your password for Nexus_
   - ID: _ci-and-cd-demo-nexus-credentials_

### Jenkinsfile

Edit `server/Jenkinsfile`:

```groovy
pipeline {
    agent any

    environment {
        IMAGE_NAME = 'ci-and-cd-demo-app'
        NEXUS_REPO_URL = "${NEXUS_HOST}/repository/${NEXUS_REPO}"
        NEXUS_CREDENTIALS_ID = 'ci-and-cd-demo-nexus-credentials' // Jenkins에 등록한 크리덴셜 ID
    }

    stages {
        stage('Clean up') {
            steps {
                sh 'sudo docker image prune -f'
            }
        }

        stage('Download Docker image from Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: env.NEXUS_CREDENTIALS_ID, usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    sh """
                        curl -u $NEXUS_USER:$NEXUS_PASS -O $NEXUS_REPO_URL/${IMAGE_NAME}.tar
                        sudo docker load -i ${IMAGE_NAME}.tar
                    """
                }
            }
        }

        stage('Run Docker container') {
            steps {
                sh """
                    sudo docker stop ${IMAGE_NAME} || true
                    sudo docker rm ${IMAGE_NAME} || true
                    sudo docker run -d --name ${IMAGE_NAME} -p 8000:8000 ${IMAGE_NAME}:latest
                """
            }
        }
    }
}
```

> [!NOTE]
> Position the `Jenkinsfile` on the `server` because it is a `server` service.

### Set up connection GitHub repository

1. Click **New Item** menu, edit and **OK**:

   - Enter an item name: _ci-and-cd-demo-pipeline_
   - Select an item type: `Pipeline`

2. Edit and **Save**:

   - General
     - 설명: "CI & CD demo pipeline"
     - [x] 이 빌드는 매개변수가 있습니다.
       - String Parameter
         - 매개변수 명: _NEXUS_HOST_
         - Default Value: _http://YOUR_IP_ADDRESS:PORT_
       - String Parameter
         - 매개변수 명: _NEXUS_REPO_
         - Default Value: _ci-and-cd-demo-artifacts_
   - Pipeline
     - Definition: `Pipeline script from SCM`
       - SCM: `Git`
         - Repositories
           - Repository URL: _https://github.com/yourusername/ci-and-cd-demo.git_
           - Credentials: `ci-and-cd-demo-personal-access-token`
       - Branches to build
         - Branch Specifier: `*/main`
       - Script Path: _server/Jenkinsfile_

## Build

1. Go to **Open Blue Ocean**
2. Click **Run**
3. Go to _http://0.0.0.0:8000_ (`server` is Django project)

## TroubleShootings

### docker: not found

원인:

- Jenkins 는 Docker 설치하지 않습니다.

해결:

- [`jenkins/Dockerfile`](#dockerfile) 에서 `docker.io` 를 설치합니다.
  - `docker` group 만듬
  - docker CLI 할 수 있음
- [`jenkins/Dockerfile`](#dockerfile) 에서`jenkins` 계정을 `docker` group 에 추가합니다.

### permission denied on /var/run/docker.sock

원인:

- `jenkins` 계정으로 `/var/run/docker.sock` 공유 및 권한 부여 필요해서 입니다:

  ```bash
  docker exec ci-and-cd-demo-jenkins-1 ls -l /var/run/docker.sock
  # srw-rw---- 1 root root 0 Apr 16 07:51 /var/run/docker.sock
  ```

- 현재 `docker-compose.yml` 에서 `/var/run/docker.sock:/var/run/docker.sock` volume 상태입니다.

- `sudo chown root:docker /var/run/docker.sock` 시, 나의 로컬 docker.sock 에 문제가 발생할 수 있습니다.

해결:

- [`server/Dockerfile`](#dockerfile) 에서 `sudo` 를 설치하고 `jenkins` 계정에 비밀번호 없이 `sudo` 실행할 권한을 부여합니다.
- [`server/Jenkinsfile`](#jenkinsfile) 에서 `docker` 명령어를 `sudo docker` 로 변경합니다.

## Deploy by SSH

### Install SSH Agent Plugin

1. Go to **Jenkins 관리**

2. Go to **plugins**

3. Go to **Available plugins Install**

4. Install **SSH Agent** or **SSH Agent Plugin**

### Generate SSH keys

Generate SSH key `jenkins-deploy`:

```bash
ssh-keygen -t ed25519 -C "jenkins-deploy" -f ~/.ssh/jenkins_deploy
```

- `-t`: Algorithm (default: `rsa`, 요즘은 `ed25519` 를 선호)
- `-C`: Comment
- `-f`: Output keyfile

Show, generated public SSH key by `jenkins-deploy`:

```bash
cat ~/.ssh/jenkins_deploy
cat ~/.ssh/jenkins_deploy.pub
```

- `~/.ssh/jenkins_deploy`: Jenkins 관리/Credentials 에서 등록합니다.
- `~/.ssh/jenkins_deploy.pub`: `deploy` container 에서 **appuser** 사용자의 `~/.ssh/authorized_keys` 에 추가합니다.

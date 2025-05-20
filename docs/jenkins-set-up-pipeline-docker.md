# Jenkins Set up pipeline for Docker

## Requirements

Refer to [this](./jenkins.md).

### Set up Plugins

1. Go to **Dashboard**

2. Go to **Jenkins 관리**

3. Go to **Plugins**

4. Check plugins and install:

   - [x] Docker Pipeline: Required
   - [x] Blue Ocean: Very useful

## Set up Pipeline

1. Go to **Dashboard**

2. Click **New Item** menu, edit and **OK**:

   - Enter an item name: _ci-and-cd-demo-pipeline_
   - Select an item type: `Pipeline`

3. Edit and **Save**:

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
       - Script Path: _server/Jenkinsfile_. Edit and **Save**:

## Build

1. Go to **Open Blue Ocean**
2. Click **Run**
3. Go to _http://0.0.0.0:8000_ (`server` is Django project)

## TroubleShootings

### docker: not found

원인:

- Jenkins 는 Docker 설치하지 않습니다.

해결:

- [`jenkins/Dockerfile`](../jenkins/Dockerfile) 에서 `docker.io` 를 설치합니다.
  - `docker` group 만듬
  - docker CLI 할 수 있음
- [`jenkins/Dockerfile`](../jenkins/Dockerfile) 에서`jenkins` 계정을 `docker` group 에 추가합니다.

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

- [`server/Dockerfile`](../jenkins/Dockerfile) 에서 `sudo` 를 설치하고 `jenkins` 계정에 비밀번호 없이 `sudo` 실행할 권한을 부여합니다.
- [`server/Jenkinsfile`](../jenkins/Dockerfile) 에서 `docker` 명령어를 `sudo docker` 로 변경합니다.

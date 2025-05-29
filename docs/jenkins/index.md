# Jenkins

## Installation

### `Dockerfile`

Edit [`Dockerfile`](../../jenkins/Dockerfile).

### Docker Compose

Add the `jenkins` service to your [`docker-compose.yml`](../docker-compose.yml).

Up docker compose:

```bash
docker compose -f "docker-compose.yml" up -d --build
```

### Initial Configuration

1. Get initial admin password

   Open your terminal. Then, execute the command:

   ```bash
   docker exec -it ci-and-cd-demo-jenkins-1 cat /var/jenkins_home/secrets/initialAdminPassword
   # 9712ee6f95984320ac2695b70c460940
   ```

   - `ci-and-cd-demo-jenkins-1`: `jenkins` service container name

2. Go to [http://localhost:8080](http://localhost:8080)

3. Edit **Unlock Jenkins**. Then, click **Continue**:

   - Administrator password: 9712ee6f95984320ac2695b70c460940

4. **Customize Jenkins**, click `Install suggested plugins`

5. Edit **Create First Admin User**. Then, click **Save and Continue**

6. No changed **Instance Configuration**. Then, click **Save and Finish**

## Configuration

### Plugins

1. Go to **Dashboard**

2. Go to **Jenkins 관리**

3. Go to **Plugins**

4. Check plugins and install:

   - [x] Pipeline

### Credentials

1. Go to **Dashboard**

2. Go to **Jenkins 관리**

3. Go to **Credentials**

4. In **Stores scoped to Jenkins**, Click **(global)** at _System_ Store

5. Click **Add Credentials** and **Save** for GitHub Personal Access Token Click

#### `ci-and-cd-demo-personal-access-token`

- Kind: `Username with password`
- Username: _Your GitHub USERNAME_
- Password: Generated [Fine-grained Personal Access Tokens](../github.md#fine-grained-personal-access-tokens)
- ID: _ci-and-cd-demo-personal-access-token_

#### `ci-and-cd-demo-nexus-credentials`

- Kind: `Username with password`
- Username: _Your username for Nexus_
- Password: _Your password for Nexus_
- ID: _ci-and-cd-demo-nexus-credentials_

#### `jenkins_deploy`

특정 Pipeline 에서 설정 된 Jenkinsfile 을 이용한 SSH Command 를 실행하는 경우, 자격 증명을 위해 필요합니다.

`jenkins_deploy` 는 Jenkins 에서 생성 된 SSH private key 입니다.

자세한 설정은 [이 곳](./pipeline-ssh-command.md#set-up-ssh-private-key-to-credentials)을 참조바랍니다.

## Set up Pipelines

- [Pipeline with Docker](./pipeline-docker.md)
- [Pipeline with SSH Command](./pipeline-ssh-command.md)

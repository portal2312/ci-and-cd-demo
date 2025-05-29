# Jenkins Pipeline with SSH Command

## Requirements

Refer to [this](./index.md).

### Plugins

1. Go to **Dashboard**

2. Go to **Jenkins 관리**

3. Go to **Plugins**

4. Check plugins and install:

   - [x] Blue Ocean
   - [x] Docker Pipeline
   - [x] SSH Agent

## Configuration

### Generate SSH keys

Go to the `jenkins` user at the `jenkins` container.

Generate SSH key `jenkins_deploy`:

```bash
ssh-keygen -t ed25519 -C "jenkins_deploy" -f ~/.ssh/jenkins_deploy
```

- `-t`: Algorithm (default: `rsa`, 요즘은 `ed25519` 를 선호)
- `-C`: Comment
- `-f`: Output keyfile

Show, generated public SSH key by `jenkins_deploy`:

```bash
cat ~/.ssh/jenkins_deploy
cat ~/.ssh/jenkins_deploy.pub
```

#### `~/.ssh/jenkins_deploy`

SSH 접속을 시도하는 [`Jenkinsfile`](../Jenkinsfile) 을 설정한 [Pipeline](#set-up-pipeline) 에서 빌드 시, 사용되는 Private Key 입니다.

#### `~/.ssh/jenkins_deploy.pub`

`deploy` container 에서 접근 및 명령어를 실행할 **appuser** 사용자의 `~/.ssh/authorized_keys` 에서 사용되는 Public Key 입니다.

### Set up SSH authorized keys to deploy

설정은 [Set up SSH authorized keys for jenkins](../deploy.md#set-up-ssh-authorized-keys-for-jenkins) 을 참조 바랍니다.

Test, try connect to **deploy** container:

```bash
ssh -i ~/.ssh/jenkins_deploy appuser@deploy
```

Test, try execute `/app/deploy_from_nexus.sh` to **deploy** container:

```bash
ssh -i ~/.ssh/jenkins_deploy -o StrictHostKeyChecking=no appuser@deploy 'bash -l -c "/app/deploy_from_nexus.sh"'
```

### Set up SSH Private Key to Credentials

생성 된 `~/.ssh/jenkins_deploy` 을 Jenkins 서비스에 등록합니다.

1. Go to **Dashboard**

2. Go to **Jenkins 관리**

3. Go to **Credentials**

4. Click **(global)** at **Stores scoped to Jenkins** table **Domains** column

5. Click **Add Credentials** and **Save** for GitHub Personal Access Token Click:

   - Kind: `SSH Username with private key`
   - ID: _jenkins_deploy_
   - Username: _appuser_ (try connect a user)
   - Private Key
     - [x] Enter directly
       - Click **Add** button at **key** item
         - Textarea: Paste the `~/.ssh/jenkins_deploy` text

### Set up Pipeline

1. Go to **Dashboard**

2. Click **New Item** menu, edit and click **OK** button:

   - Enter an item name: _ci-and-cd-demo_
   - Select an item type: `Pipeline`

3. Edit and click **Save** button:

   - General
     - 설명: "CI & CD demo pipeline"
   - Pipeline
     - Definition: `Pipeline script from SCM`
       - SCM: `Git`
         - Repositories
           - Repository URL: _https://github.com/username/ci-and-cd-demo.git_
           - Credentials: [`ci-and-cd-demo-personal-access-token`](./index.md#ci-and-cd-demo-personal-access-token)
       - Branches to build
         - Branch Specifier: `*/main`
       - Script Path: [`Jenkinsfile`](../Jenkinsfile)

## Set up Generic Webhook Trigger

> [!IMPORTANT]
> GitHub Actions 의 workflows 에서 설정 된 Jenkins 의 pipeline 에 Generic Webhook Trigger 의 API 를 호출하는 방식입니다.  
> 이것은 GitHub Actions 의 Webhooks 과 관련 없습니다.

예제 시나리오:

1. Push `main` branch
2. **GitHub Actions** 의 workflows 목록에서 Push `main` branch 에 대해 작성 된 workflow 가 자동 실행
3. 실행 중인 workflow 작업 목록에서 **Generic Webhook Trigger** API 를 호출 (일반적으로 마지막에 호출)
4. 호출 받은 **Generic Webhook Trigger** API 를 설정 한 **Jenkins** 의 **Pipeline** 이 자동 build

[Generic Webhook Trigger](./generic-webhook-trigger.md) 설정 하기.

## Build

1. Go to **Open Blue Ocean**
2. Click **Run**

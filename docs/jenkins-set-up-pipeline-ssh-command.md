# Jenkins Set up pipeline for SSH Command

## Requirements

Refer to [this](./jenkins.md).

### Set up Plugins

1. Go to **Dashboard**

2. Go to **Jenkins 관리**

3. Go to **Plugins**

4. Check plugins and install:

   - [x] SSH Agent (or SSH Agent Plugin)

## Configuration

### Set up SSH keys

Go to the `jenkins` user at the `jenkins` container.

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

### Set Up SSH authorized keys on deploy

Refer to [this](./deploy.md#set-up-ssh-authorized-keys-for-jenkins).

### Set up Pipeline

Go to [`http://localhost:8080`](http://localhost:8080).

1. Go to **Dashboard**

2. Click **New Item** menu, edit and **OK**:

   - Enter an item name: _ci-and-cd-demo-pipeline_
   - Select an item type: `Pipeline`

3. Edit and **Save**:

   - General
     - 설명: "CI & CD demo pipeline"
   - Pipeline
     - Definition: `Pipeline script from SCM`
       - SCM: `Git`
         - Repositories
           - Repository URL: _https://github.com/yourusername/ci-and-cd-demo.git_
           - Credentials: `ci-and-cd-demo-personal-access-token`
       - Branches to build
         - Branch Specifier: `*/main`
       - Script Path: [`Jenkinsfile`](../Jenkinsfile)

## Build

1. Go to **Open Blue Ocean**
2. Click **Run**

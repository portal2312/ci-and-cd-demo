# Set up Web Hooks

## Jenkins

### Set up Plugins

Already, installed [requirement plugins](./jenkins.md#plugins).

1. Go to **Dashboard**

2. Go to **Jenkins 관리**

3. Go to **Plugins**

4. Check plugins and install:

   - [x] Generic Webhook Trigger

### Set up Pipeline

> [!TIP]
> 이미 등록 된 pipeline 유형의 item 에서도 설정할 수 있습니다.

1. Go to **Dashboard**

2. Click **New Item** menu, edit and click **OK** button:

   - Enter an item name: _ci-and-cd-demo-pipeline_
   - Select an item type: `Pipeline`

3. Edit and click **Save** button:

   - General
     - 설명: "CI & CD demo pipeline"
   - Triggers
     - [x] Generic Webhook Trigger
       - Token: _JENKINS_JOB_TOKEN_
   - Pipeline
     - Definition: `Pipeline script from SCM`
       - SCM: `Git`
         - Repositories
           - Repository URL: _https://github.com/username/ci-and-cd-demo.git_
           - Credentials: _GITHUB_PERSONAL_ACCESS_TOKEN_
       - Branches to build
         - Branch Specifier: `*/main`
       - Script Path: [`Jenkinsfile`](../Jenkinsfile)

## GitHub

### Set up GitHub Workflows for CI

`.github/workflows/*.yml`:

```yml
# ...exists configuration...

jobs:
  deploy:
    steps:
      # ...exists configuration...

      - name: Notify Jenkins
        run: |
          curl -X POST "${{ secrets.JENKINS_URL }}/generic-webhook-trigger/invoke?token=${{ secrets.JENKINS_JOB_TOKEN }}"
```

### Actions secrets and variables

1. Go to **Your Repository**

2. Click **Settings** tab

3. Click **Security/Secrets and variables/Actions** menu

4. In **Repository secrets**, and click **New repository secret** button

5. Edit and save:

- Name: `JENKINS_URL`  
  Secret: _JENKINS_URL_ (ex: `http://YOUR_REAL_IP_ADDRESS:8080`)

  > [!IMPORTANT]
  > Already, Set up [Port Forwarding](./port_forwarding.md).

- Name: `JENKINS_JOB_TOKEN`  
  Secret: [_JENKINS_JOB_TOKEN_](#set-up-pipeline)

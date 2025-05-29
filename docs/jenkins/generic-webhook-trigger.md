# Jenkins Pipeline Generic Webhook Trigger

## Jenkins

### Install Plugins

1. Go to **Dashboard**

2. Go to **Jenkins 관리**

3. Go to **Plugins**

4. Check plugins and install:

   - [x] Generic Webhook Trigger

### Update Pipeline

1. Go to **Dashboard**

2. Click your item:

3. Update and click **Save** button:

   - Triggers
     - [x] Generic Webhook Trigger
       - Token: _JENKINS_JOB_TOKEN_

## GitHub

### Update Workflow

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

#### `JENKINS_URL`

Try, refer GitHub to Jenkins URL: `http://YOUR_REAL_IP_ADDRESS:8080`

> [!IMPORTANT]
> Already, Set up [Port Forwarding](./port_forwarding.md).

#### `JENKINS_JOB_TOKEN`

Generic Webhook Trigger Token into the [Pipeline](#update-pipeline).

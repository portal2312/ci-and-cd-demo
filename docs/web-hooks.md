# Set up Web Hooks

## GitHub

### Add Webhooks

1. Go to your `ci-and-cd-demo` repository

2. Click **Settings** menu

3. Click **Webhooks** right sub menu

4. Click [**Add Webhooks**](https://github.com/username/ci-and-cd-demo/settings/hooks/new) button

   > [!NOTE]
   > Go to [**Add Webhooks**](https://github.com/username/ci-and-cd-demo/settings/hooks/new), then change `username` to your GitHub username.

5. Edit, then click the `Add webhook` button:

   - Payload URL: _http://YOUR_REAL_IP_ADDRESS:8082/github-webhook/_

     > [!IMPORTANT]
     > Already, Set up [Port Forwarding](./port_forwarding.md).

   - Content type: `application/json`

   - SSL verification:

     - [ ] Enable SSL verification
     - [x] Disable (not recommended): **Only using the test.**

   - Which events would you like to trigger this webhook?

     - [x] Just the push event.

### Generate permission Personal-Access-Tokens

Refer to [Generate Personal-Access-Tokens](./github.md#generate-personal-access-tokens).

## Jenkins

### Set up Plugins

1. Go to **Dashboard**

2. Go to **Jenkins 관리**

3. Go to **Plugins**

4. Check plugins and install:

   - [x] Git Plugin
   - [x] GitHub Plugin

### Set up Pipeline

1. Go to **Dashboard**

2. Click **New Item** menu, edit and click **OK** button:

   - Enter an item name: _ci-and-cd-demo-pipeline_
   - Select an item type: `Pipeline`

3. Edit and click **Save** button:

   - General
     - 설명: "CI & CD demo pipeline"
   - Triggers
     - [x] GitHub hook trigger for GITScm polling
   - Pipeline
     - Definition: `Pipeline script from SCM`
       - SCM: `Git`
         - Repositories
           - Repository URL: _https://github.com/username/ci-and-cd-demo.git_
           - Credentials: `ci-and-cd-demo-personal-access-token`
       - Branches to build
         - Branch Specifier: `*/main`
       - Script Path: [`Jenkinsfile`](../Jenkinsfile)

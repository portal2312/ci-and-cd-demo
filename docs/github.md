# GitHub

## Set up Repository

Create `ci-and-cd-demo` public Repository.

And, push your local project to `git://github.com/USERNAME/ci-and-cd-demo.git`:

```bash
git init
git remote add origin git://github.com/USERNAME/ci-and-cd-demo.git
git add .
git commit -m "Initial commit"
git push -u origin main
```

## Set up GitHub Workflows

By a runner:

- [GitHub Actions Runner](../.github/workflows/actions-main.yml)
- [Self Hosted Runner](../.github/workflows/self-hosted-main.yml)

## Set up GitHub Actions environments

### Actions secrets and variables

1. Go to **Your Repository**

2. Go to **Settings** tab

3. Click **Security/Secrets and variables/Actions** right sub menu

4. In **Repository secrets**, and click **New repository secret** button. Then **Save**.

#### Repository secrets

| Name                                                                        | Secret                           |
| --------------------------------------------------------------------------- | -------------------------------- |
| [JENKINS_JOB_TOKEN](./jenkins/generic-webhook-trigger.md#jenkins_job_token) | ci-and-cd-demo Job Token         |
| [JENKINS_URL](./jenkins/generic-webhook-trigger.md#jenkins_url)             | http://YOUR_REAL_IP_ADDRESS:8080 |
| [NEXUS_PASSWORD](./nexus.md#nexus_password)                                 | NEXUS_USER password              |
| [NEXUS_REPO](./nexus.md#nexus_repo)                                         | ci-and-cd-demo-artifacts         |
| [NEXUS_URL](./nexus.md#nexus_url)                                           | http://YOUR_REAL_IP_ADDRESS:8081 |
| [NEXUS_USER](./nexus.md#nexus_user)                                         | admin                            |
| [POSTGRES_DB](./db.md#postgres_db)                                          |                                  |
| [POSTGRES_HOST](./db.md#postgres_host)                                      |                                  |
| [POSTGRES_PASSWORD](./db.md#postgres_password)                              |                                  |
| [POSTGRES_PORT](./db.md#postgres_port)                                      |                                  |
| [POSTGRES_USER](./db.md#postgres_user)                                      |                                  |

### Fine-grained Personal Access Tokens

1. Click **Profile**

2. Go to **Settings** menu

3. Go to **Developer settings** right sub menu

4. Click **Personal access tokens/Fine grained tokens** sub menu

5. Select **Generate new token**

6. Edit and Select **Generate token**:

   - Token name: _ci-and-cd-demo-personal-access-token_
   - Expiration: _expiry date_
   - Repository access: `Only select repositories`
     - [x] ci-and-cd-demo
   - Permissions
     - Repository permissions
       - Contents: `Read-only` (Required)
       - Webhooks: `Read and write` (Optional, useful)

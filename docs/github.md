# GitHub

## Set up Repository

Create `ci-and-cd-demo` public Repository.

And, push your local project to `git://github.com/YOUR_USERNAME/ci-and-cd-demo.git`:

```bash
git init
git remote add origin git://github.com/YOUR_USERNAME/ci-and-cd-demo.git
git add .
git commit -m "Initial commit"
git push -u origin main
```

## Set up GitHub Workflows for CI

By a runner:

- [GitHub Actions Runner](../.github/workflows/ci.yml)
- [Self Hosted Runner](../.github/workflows/ci-self-hosted-runner.yml)

## Set up GitHub Actions

### Secrets and Variables

1. Go to **Your Repository**

2. Click **Settings** tab

3. Click **Security/Secrets and variables/Actions** menu

4. In **Repository secrets**, and click **New repository secret** button

5. Edit and save:

- Name: `NEXUS_USER`  
  Secret: _admin_

- Name: `NEXUS_PASSWORD`  
  Secret: _YOUR_PASSWORD_

- Name: `NEXUS_HOST`  
  Secret: _http://YOUR_REAL_IP_ADDRESS:8080_

  > [!IMPORTANT]
  > Already, Set up [Port Forwarding](./port_forwarding.md).

- Name: `NEXUS_REPO`  
  Secret: _ci-and-cd-demo-artifacts_

### Generate Personal-Access-Tokens

1. Click **Profile**, Then Go to **Settings** menu

2. Go to **Developer settings** sub menu

3. Click **Personal access tokens/Fine grained tokens** sub menu

4. Select **Generate new token**

5. Edit and Select **Generate token**:

   - Token name: _ci-and-cd-demo-personal-access-token_
   - Expiration: _expiry date_
   - Repository access: `Only select repositories`
     - [x] ci-and-cd-demo
   - Permissions
     - Repository permissions
       - Contents: `Read-only`

# GitHub

## Set up Repository

Create `ci-and-cd-demo` public Repository.

And, push your local project:

```bash
git init
git remote add origin git://github.com/yourusername/ci-and-cd-demo.git
git add .
git commit -m "Initial commit"
git push -u origin main
```

## Set up GitHub Actions (CI)

CI steps:

- Install Python dependencies
- Django migrate
- Run tests
- Build `ci-and-cd-demo-app:latest` Docker image from `./server`
- Save Docker image as tar file
- Upload Docker image to Nexus

> [!NOTE]
> CI: build, tests, lint, migrate.

Add `.github/workflows/ci.yml`:

```yml
name: ci-and-cd-demo-ci

on:
  push:
    branches:
      - main

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - name: Check out code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          # 최신 버전은 일부 라이브러리나 GitHub Actions 이미지에서 완전히 지원 안 될 수도 있으니 주의하기.
          python-version: 3.11

      - name: Install Python dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r server/requirements.txt
          pip install pytest pytest-django

      - name: Run migrations
        run: python server/manage.py migrate --noinput

      - name: Run tests
        run: pytest --config-file server/pytest.ini server

      - name: Set up Docker
        uses: docker/setup-buildx-action@v3

      - name: Build Docker image
        run: docker build -f server/Dockerfile -t ci-and-cd-demo-app:latest ./server

      - name: Save Docker image as tar file
        run: docker save ci-and-cd-demo-app:latest -o server/ci-and-cd-demo-app.tar

      - name: Upload Docker image to Nexus
        run: |
          curl -v -u ${{ secrets.NEXUS_USER }}:${{ secrets.NEXUS_PASSWORD }} \
            --upload-file server/ci-and-cd-demo-app.tar \
            ${{ secrets.NEXUS_HOST }}/repository/${{ secrets.NEXUS_REPO }}/ci-and-cd-demo-app.tar
```

### Actions secrets and variables

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

  > [!NOTE]
  > Usually, you have to set up [Port Forwarding](./port_forwarding.md).

- Name: `NEXUS_REPO`  
  Secret: _ci-and-cd-demo-artifacts_

## Generate Personal-Access-Tokens

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

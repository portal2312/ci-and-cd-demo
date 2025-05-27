# Nexus

## Installation

### Docker Compose

Add the `nexus` service to your [`docker-compose.yml`](../docker-compose.yml).

Up docker compose:

```bash
docker compose -f "docker-compose.yml" up -d --build
```

### Initial Configuration

1. Get initial admin password

   Open your terminal. Then, execute the command:

   ```bash
   docker exec -it ci-and-cd-demo-nexus-1 cat /nexus-data/admin.password
   # 9f43c0b2-4e9f-4b78-b649-bd4280c5c12f
   ```

   - `ci-and-cd-demo-nexus-1`: `nexus` service container name

2. Go to [http://localhost:8081](http://localhost:8081)

3. Try, **Sign in**:

   - ID: _admin_
   - Password: _9f43c0b2-4e9f-4b78-b649-bd4280c5c12f_

4. **Please choose a password for the admin user**, then **Next**:

   - New password:
   - Confirm password:

5. **Configure Anonymous Access**, then **Next**:

   - [ ] Enable anonymous access
   - [x] Disable anonymous access

## Configuration

### Set up Blob Storage

1. Go to **⚙️ Repository** menu

2. Go to **Blob Stores** sub menu

3. click **Create Blob Store** button

4. Edit and save:

   - Type: `File`
   - Name: _ci-and-cd-demo_store_
   - Path: (auto-completion)

### Set up Repositories

1. Go to **⚙️ Repository** menu

2. Go to **Repositories** right sub menu

3. Click **Create repository**

4. Click `raw (hosted)` item

5. Edit and click **Create repository**:

   - Name: _ci-and-cd-demo-artifacts_
   - Blob store: `ci-and-cd-demo`

6. Click created `ci-and-cd-demo-artifacts` repository

7. Look at the URL:
   `http://localhost:8081/repository/ci-and-cd-demo-artifacts/`

### Set up Port Forwarding

Refer to [Port Forwarding](./port_forwarding.md).

### Set Environment Variables

Edit [`.env`](../.env):

```bash
NEXUS_URL=http://nexus:8081
NEXUS_PASSWORD=
NEXUS_USER=admin
NEXUS_REPO=ci-and-cd-demo-artifacts
```

#### `NEXUS_URL`

> [!IMPORTANT]
> 환경 변수 `NEXUS_URL` 는 로컬에서 참조 시, `http://nexus:8081` 를 사용해도 된다.  
> 하지만, GitHub Actions 의 workflows 를 사용하기 위해 secrets and variables 등록과 같이 외부에서 참조하는 경우, 나의 실제 IP와 설정 된 [Port Forwarding](./port_forwarding.md)의 port 를 작성해야 한다.

#### `NEXUS_PASSWORD`

Nexus [`NEXUS_USER`](#nexus_user) password.

#### `NEXUS_USER`

Nexus username.

#### `NEXUS_REPO`

[Set up Repositories](#set-up-repositories) 에서 생성 된 저장소 이름.

## Etc

파일(컴포넌트) 목록 조회:

```bash
curl -u ${NEXUS_USER}:${NEXUS_PASSWORD} ${NEXUS_URL}/service/rest/v1/components?repository=${NEXUS_REPO}
```

파일(컴포넌트) 삭제:

```bash
curl -u ${NEXUS_USER}:${NEXUS_PASSWORD} -X DELETE ${NEXUS_URL}/service/rest/v1/components/${COMPONENT_ID}
```

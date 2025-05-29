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
> Define `http://nexus:8081` at your local. For example, by docker compose container.  
> But, define your _real IP_ if you want to use an external. For example, GitHub Actions Secrets and Variables.
> Then, your need to [Port Forwarding](./port_forwarding.md)

#### `NEXUS_PASSWORD`

Nexus [`NEXUS_USER`](#nexus_user) password.

#### `NEXUS_USER`

Nexus username.

#### `NEXUS_REPO`

Generated repo name by [Set up Repositories](#set-up-repositories).

## Etc

Show files(components):

```bash
curl -u ${NEXUS_USER}:${NEXUS_PASSWORD} ${NEXUS_URL}/service/rest/v1/components?repository=${NEXUS_REPO}
```

Delete file(component):

```bash
curl -u ${NEXUS_USER}:${NEXUS_PASSWORD} -X DELETE ${NEXUS_URL}/service/rest/v1/components/${COMPONENT_ID}
```

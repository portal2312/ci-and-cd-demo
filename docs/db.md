# Database

## Postgres

### `Dockerfile`

Edit [`Dockerfile`](../../jenkins/Dockerfile).

### Docker Compose

Add the `db` service to your [`docker-compose.dev.yml`](../docker-compose.dev.yml).

Up docker compose:

```bash
docker compose -f "docker-compose.yml" -f "docker-compose.dev.yml" up -d --build
```

### Environment variables

#### `POSTGRES_DB`

Postgres database name (default: `postgres`).

#### `POSTGRES_INITDB_ARGS`

Postgres initdb arguments.

#### `POSTGRES_HOST`

Postgres host.

#### `POSTGRES_PASSWORD`

Postgres [`POSTGRES_USER`](#postgres_user) password.

#### `POSTGRES_PORT`

Postgres port (default: `5432`).

#### `POSTGRES_USER`

Postgres user (default: `postgres`).

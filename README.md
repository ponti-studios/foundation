# foundation

Shared infrastructure layer for the ponti-studios org. Single source of truth for PostgreSQL, Redis, compose stacks, and CI/CD — consumed as published artifacts by labs and hominem.

## What's here

```
foundation/
├── compose/              # Docker Compose stack (base, dev, test)
├── images/postgres/      # PostgreSQL 18 + pgvector + PostGIS + pgRouting
├── docs/                 # Local dev and deployment guides
├── .github/workflows/    # CI: image publishing
└── justfile              # Shared task runner
```

## Quick start

```bash
# Start local infra (postgres + redis + minio)
just up

# Verify services are healthy
just health

# Stop services
just down

# Validate compose config
just validate-compose
```

## Images

| Image | Registry | Description |
|---|---|---|
| PostgreSQL | `ghcr.io/ponti-studios/hominem/postgres@sha256:86cf2d9db9d56afb3238c55c4fdced6c011d3a1a8503e9e360f8ca82ded80124` | PG 18 + pgvector 0.8.2 + PostGIS + pgRouting |

## Consuming from labs or hominem

Use the published postgres image directly in your compose files:

```yaml
services:
  db:
    image: ghcr.io/ponti-studios/hominem/postgres@sha256:86cf2d9db9d56afb3238c55c4fdced6c011d3a1a8503e9e360f8ca82ded80124
```

Use the digest above when you need a reproducible production or staging deployment. The compose stack builds the same image locally by default.

## Local development

See [docs/LOCAL_DEV.md](docs/LOCAL_DEV.md)

## Deploying to Railway

See [docs/RAILWAY_DEPLOYMENT.md](docs/RAILWAY_DEPLOYMENT.md)

## Publishing the postgres image

Run the GitHub Actions workflow manually to bump the version tag and publish the image:

```bash
gh workflow run publish-postgres.yml -f version_part=patch
```

The workflow creates a `postgres-v*` tag in the repo and publishes the image to GHCR as a semver tag. For deployment, prefer the digest-pinned reference above.

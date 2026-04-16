# foundation

Shared infrastructure layer for the ponti-studios org. Single source of truth for PostgreSQL, Redis, compose stacks, CI/CD, and observability — consumed as published artifacts by labs and hominem.

## What's here

```
foundation/
├── compose/              # Docker Compose stack (base, dev, test)
├── images/postgres/      # PostgreSQL 18 + pgvector + PostGIS + pgRouting
├── observability/        # Jaeger, OTel, Sentry setup
├── railway/              # Railway deployment templates and env examples
├── scripts/              # Shared automation scripts
├── docs/                 # Getting started and deployment guides
├── .github/workflows/    # CI: image publishing, compose validation
└── justfile              # Shared task runner
```

## Quick start

```bash
# Start local infra (postgres + redis)
just docker-up

# Verify services are healthy
just health-check

# Stop services
just docker-down

# Validate compose config
just validate-compose
```

## Images

| Image | Registry | Description |
|---|---|---|
| PostgreSQL | `ghcr.io/ponti-studios/hominem/postgres:latest` | PG 18 + pgvector 0.8.2 + PostGIS + pgRouting |

## Consuming from labs or hominem

Use the published postgres image directly in your compose files:

```yaml
services:
  db:
    image: ghcr.io/ponti-studios/hominem/postgres:latest
```

Pin to a specific version:

```bash
ghcr.io/ponti-studios/hominem/postgres:0.8.2
```

## Local development

See [docs/LOCAL_DEV.md](docs/LOCAL_DEV.md)

## Deploying to Railway

See [docs/RAILWAY_DEPLOYMENT.md](docs/RAILWAY_DEPLOYMENT.md)

## Publishing the postgres image

The image is published automatically via GitHub Actions when a tag matching `postgres-v*` is pushed:

```bash
git tag postgres-v0.8.2 && git push origin postgres-v0.8.2
```

Or trigger manually via GitHub Actions UI.

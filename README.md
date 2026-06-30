# foundation

Shared infrastructure layer for the ponti-studios org. Single source of truth for PostgreSQL, Redis, compose stacks, and CI/CD — consumed as published artifacts by labs and hominem.

## What's here

```
foundation/
├── catalog/              # Machine-readable image, service, and digest inventory
├── compose/              # Docker Compose stack (base, dev, test)
├── docs/                 # Local dev, deploy, release, and security docs
├── images/postgres/      # PostgreSQL 18 + pgvector + PostGIS + pgRouting
├── templates/            # Placeholder for future provider templates
├── .github/workflows/    # CI and image publishing
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
| PostgreSQL | `ghcr.io/ponti-studios/foundation/postgres@sha256:86cf2d9db9d56afb3238c55c4fdced6c011d3a1a8503e9e360f8ca82ded80124` | PG 18 + pgvector 0.8.2 + PostGIS + pgRouting |

## Consuming from labs or hominem

Use the published postgres image directly in your compose files:

```yaml
services:
  db:
    image: ghcr.io/ponti-studios/foundation/postgres@sha256:86cf2d9db9d56afb3238c55c4fdced6c011d3a1a8503e9e360f8ca82ded80124
```

Use the digest above when you need a reproducible production or staging deployment. The compose stack builds the same image locally by default.

## Local development

See [docs/local-dev.md](docs/local-dev.md)

## Deployment

See [docs/deploy.md](docs/deploy.md)

## Releases

See [docs/releases.md](docs/releases.md)

## Security

See [docs/security.md](docs/security.md)

## Publishing the postgres image

Pushes to `main` automatically bump the patch version tag and publish the image. Use a manual dispatch only when you need a major or minor bump:

```bash
gh workflow run publish-postgres.yml -f version_part=minor
```

The workflow creates a canonical `v*` git tag in the repo and publishes the image to GHCR as the matching semver image tag without the `v` prefix. For deployment, prefer the digest-pinned reference above.

# Deployment

Use the digest-pinned postgres image for production or staging:

```text
ghcr.io/ponti-studios/hominem/postgres@sha256:86cf2d9db9d56afb3238c55c4fdced6c011d3a1a8503e9e360f8ca82ded80124
```

That digest is the stable deploy target produced by the publish workflow.

## Environment

| Variable | Description | Example |
|---|---|---|
| `POSTGRES_USER` | Database user | `postgres` |
| `POSTGRES_PASSWORD` | Database password | set in your platform vars |
| `POSTGRES_DB` | Default database name | `hominem` |
| `DATABASE_URL` | Full connection string | `postgresql://...` |

## Templates

This repo does not currently ship provider-specific deployment templates. Use the image reference and environment contract above directly in your target platform.

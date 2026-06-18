# Railway Deployment

## Using the postgres image

In your Railway project, set the postgres service to use:

```
ghcr.io/ponti-studios/hominem/postgres@sha256:86cf2d9db9d56afb3238c55c4fdced6c011d3a1a8503e9e360f8ca82ded80124
```

Use the digest-pinned reference above for production or staging. It is the stable deploy target produced by the publish workflow.

## Environment variables

| Variable | Description | Example |
|---|---|---|
| `POSTGRES_USER` | Database user | `postgres` |
| `POSTGRES_PASSWORD` | Database password | (set in Railway vars) |
| `POSTGRES_DB` | Default database name | `hominem` |
| `DATABASE_URL` | Full connection string | `postgresql://...` |

## Railway templates

This repo does not currently ship Railway templates. Use the image and environment variable values above directly in your Railway service configuration.

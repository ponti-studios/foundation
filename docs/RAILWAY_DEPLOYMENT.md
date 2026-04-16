# Railway Deployment

## Using the postgres image

In your Railway project, set the postgres service to use:

```
ghcr.io/ponti-studios/hominem/postgres:latest
```

Or pin to a specific version:

```
ghcr.io/ponti-studios/hominem/postgres:0.8.2
```

## Environment variables

| Variable | Description | Example |
|---|---|---|
| `POSTGRES_USER` | Database user | `postgres` |
| `POSTGRES_PASSWORD` | Database password | (set in Railway vars) |
| `POSTGRES_DB` | Default database name | `hominem` |
| `DATABASE_URL` | Full connection string | `postgresql://...` |

## Railway templates

See `railway/templates/` for service configuration templates.

# Deployment

Use the digest-pinned Postgres image for local CI or a self-managed PostgreSQL
deployment:

```text
ghcr.io/ponti-studios/foundation/postgres@sha256:578d34f82b21752b9e749776e955fadc85e1cba8d962e78bce1bd60878a9c316
```

That digest is the published `1.0.11` deploy target produced by the publish
workflow. Railway's existing PostgreSQL service is not replaced by a second
database. Hominem services continue to use Railway's injected `DATABASE_URL`.

## Railway custom Postgres

The Hominem production database is a Railway service running the published
custom image from this repository. The deployment flow is:

1. Merge the image change to `main` in foundation.
2. `publish-postgres.yml` builds and publishes a new semver image plus
   `:latest` to GHCR.
3. Record the resulting image digest in `catalog/images.yaml`,
   `catalog/digests.yaml`, and the release record.
4. Railway's auto-update checks the existing `:latest` source and deploys the
   new image during its configured update window. Trigger an approved manual
   redeploy only when the release needs to happen sooner.
5. Keep the existing Railway volume mounted at
   `/var/lib/postgresql`, and keep the existing database variables and
   service references unchanged.
6. Verify PostgreSQL connectivity, extension versions, Hominem `/api/status`,
   migrations, and application smoke tests.

The public GHCR package lets Railway pull the image without registry
credentials. Railway's Docker-image service model preserves the service's
volume across deployments. The service is already configured for automatic
updates of `:latest`; confirm the deployment completes before running database
verification.

For maintenance, take a Railway volume backup when the dashboard makes one
available and always create and verify a custom-format `pg_dump` before any
database mutation. Railway PITR is unavailable for this custom image. After
the new container is healthy, check and update only installed extensions in the
target database as needed:

```sql
SELECT version();
SELECT extname, extversion
FROM pg_extension
WHERE extname IN ('vector', 'postgis', 'pgrouting')
ORDER BY extname;

ALTER EXTENSION vector UPDATE;
```

Run an `ALTER EXTENSION` statement only when that extension is installed and
an update is available. Hominem currently requires `vector`; do not install
PostGIS or pgRouting just because the image includes them. After an extension
upgrade, recover from the verified dump or a pre-change volume backup before
reverting the image, since a legacy image alone can have incompatible extension
binaries. Do not delete or recreate the Railway database service.

## Environment

| Variable | Description | Example |
|---|---|---|
| `POSTGRES_USER` | Database user | `postgres` |
| `POSTGRES_PASSWORD` | Database password | set in your platform vars |
| `POSTGRES_DB` | Default database name | `hominem` |
| `DATABASE_URL` | Full connection string | `postgresql://...` |

## Templates

This repo does not currently ship provider-specific deployment templates. Use the image reference and environment contract above directly in your target platform.

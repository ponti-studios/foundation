# Deployment

Use the digest-pinned Postgres image for local CI or a self-managed PostgreSQL
deployment:

```text
ghcr.io/ponti-studios/foundation/postgres@sha256:86cf2d9db9d56afb3238c55c4fdced6c011d3a1a8503e9e360f8ca82ded80124
```

That digest is the last published deploy target produced by the publish
workflow. The source changes for the upgrade are not deployable until the
publish workflow produces a new image and digest. Railway's existing
PostgreSQL service is not replaced by a second database. Hominem services
continue to use Railway's injected `DATABASE_URL`.

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
   `/var/lib/postgresql/data`, and keep the existing database variables and
   service references unchanged.
6. Verify PostgreSQL connectivity, extension versions, Hominem `/api/status`,
   migrations, and application smoke tests.

Railway must have read-only GHCR credentials for the private image. Railway's
Docker-image service model supports this workflow and preserves the service's
volume across deployments. The service is already configured for automatic
updates of `:latest`; confirm the deployment completes before running database
verification.

For this upgrade, take a Railway backup or snapshot first. PostgreSQL 18.6 is
a minor upgrade and does not require dump/restore. After the new container is
healthy, check and update installed extensions in the target database as
needed:

```sql
SELECT version();
SELECT extname, extversion
FROM pg_extension
WHERE extname IN ('vector', 'postgis', 'pgrouting')
ORDER BY extname;

ALTER EXTENSION vector UPDATE;
ALTER EXTENSION postgis UPDATE;
ALTER EXTENSION pgrouting UPDATE;
```

Run the `ALTER EXTENSION` statements only when the corresponding extension is
installed and an update is available. Rollback means redeploying the previous
image digest against the same volume; do not delete or recreate the Railway
database service.

## Environment

| Variable | Description | Example |
|---|---|---|
| `POSTGRES_USER` | Database user | `postgres` |
| `POSTGRES_PASSWORD` | Database password | set in your platform vars |
| `POSTGRES_DB` | Default database name | `hominem` |
| `DATABASE_URL` | Full connection string | `postgresql://...` |

## Templates

This repo does not currently ship provider-specific deployment templates. Use the image reference and environment contract above directly in your target platform.

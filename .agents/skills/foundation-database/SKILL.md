---
name: foundation-database
description: Publish and maintain Foundation's PostgreSQL image and release records. Use for changes to the Foundation database image, its GitHub release workflow, GHCR tags or digests, and Railway deployment guidance; not for live Hominem database maintenance.
---

# Foundation database

Foundation owns the reusable PostgreSQL image in
`/Users/charlesponti/Developer/infra/foundation/images/postgres`. It ships
PostgreSQL 18, pgvector, PostGIS, and pgRouting. It does not decide which
extensions a consuming database installs.

## Release workflow

1. Inspect the image Dockerfile, published workflow, and current catalog
   digest before changing the image.
2. Test the image's server and required extension control files before
   publishing.
3. Merge image-affecting changes to `main`. The publish workflow is limited to
   `images/postgres/**`; it creates the semver tag and updates GHCR `:latest`.
   Use manual dispatch for an intentional major or minor version bump.
4. Wait for the GitHub workflow to finish successfully. Record the resulting
   immutable digest in `catalog/images.yaml`, `catalog/digests.yaml`, and
   `docs/deploy.md`.

Do not make documentation-only changes trigger a new image or move `:latest`.
Use digest pins for CI and self-managed deployments. Hominem production is
intentionally configured to track `:latest` with Railway auto-update enabled.

## Hominem Railway contract

The Hominem production service is an existing Railway Docker-image service.
Keep its persistent volume mounted at `/var/lib/postgresql`; its `PGDATA` is
managed inside the image. Never recommend recreating the service, replacing its
volume, or changing its mount path as part of an image rollout.

The package is public at `ghcr.io/ponti-studios/foundation/postgres`, so Railway
does not require registry credentials. A successful image publication only makes
an auto-update eligible: observe a terminal Railway `SUCCESS` deployment before
claiming the database has upgraded.

## Extension and recovery policy

An image providing an extension does not install it in a consumer database.
Hominem requires `vector`; PostGIS and pgRouting must stay uninstalled unless a
consumer explicitly adopts them.

Before a runtime or extension change, require the consumer to make and verify a
logical backup. For Hominem's custom image, Railway PITR is unavailable. A
pre-change Railway volume backup is useful when the dashboard and plan allow it,
but a verified custom-format `pg_dump` is mandatory.

After an extension catalog upgrade, do not treat redeploying an older image as a
safe rollback by itself. Restore a verified logical dump or the pre-change
volume before reverting to binaries that may not match the upgraded catalog.

For live Hominem checks, backups, extension upgrades, migrations, collation
maintenance, or rollback, use `$hominem-database` and `$use-railway`.

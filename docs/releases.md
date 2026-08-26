# Releases

The postgres image is released from `.github/workflows/publish-postgres.yml`.

## Release flow

1. Merge a change under `images/postgres/` to `main`.
2. The workflow bumps the patch version by default.
3. The workflow maintains canonical git tags as `v*`.
4. The workflow publishes the image to GHCR using the matching semver image tag without the `v` prefix and updates `latest`.
5. Use manual dispatch only when you need a major or minor bump.

Documentation-only changes do not publish a new image or move `latest`.

After publishing a Postgres image, update the deployed digest in
`catalog/images.yaml`, `catalog/digests.yaml`, and `docs/deploy.md` before
deploying it to a digest-pinned environment. Railway's existing custom
Postgres service tracks `:latest` with auto-updates enabled, so publishing the
new image makes it eligible for Railway's configured update window. Publishing
does not necessarily restart the service immediately; verify the Railway
deployment after the update window or trigger the approved redeploy.

## Version policy

- Repo code and workflow dependencies are pinned to immutable commit SHAs.
- Runtime images are pinned by digest in the stack and docs.
- Dependabot is responsible for refreshing pinned actions and image references.

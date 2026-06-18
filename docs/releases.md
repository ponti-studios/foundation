# Releases

The postgres image is released from `.github/workflows/publish-postgres.yml`.

## Release flow

1. Merge to `main`.
2. The workflow bumps the patch version by default.
3. The workflow tags the repo as `postgres-v*`.
4. The workflow publishes the image to GHCR using the semver tag.
5. Use manual dispatch only when you need a major or minor bump.

## Version policy

- Repo code and workflow dependencies are pinned to immutable commit SHAs.
- Runtime images are pinned by digest in the stack and docs.
- Dependabot is responsible for refreshing pinned actions and image references.

# Local Development

`foundation` ships a self-contained local stack for PostgreSQL, Redis, and MinIO.

## Start

```bash
just up
```

This starts:
- `postgres` on port `5434`
- `postgres-test` on port `4433`
- `redis` on port `6379`
- `minio` on ports `9000` and `9001`

The postgres image is built locally from the checked-in Dockerfile. If you need the published artifact for debugging, use the digest-pinned reference from [README.md](../README.md#images).

## Health

```bash
just health
```

## Stop

```bash
just down
```

## Reset

```bash
just kill
```

## Notes

- No env files are required or shipped.
- Compose defaults are in the compose files themselves.
- If you need an override, set the variable in your shell for that invocation.

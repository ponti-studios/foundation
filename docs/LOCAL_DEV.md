# Local development with foundation

## Prerequisites

- Docker
- [just](https://github.com/casey/just)
- Go (for goose migrations)

## Start local infrastructure

```bash
just up
```

This starts:
- **postgres** on port `5434` (dev database)
- **postgres-test** on port `4433` (test database)
- **redis** on port `6379`
- **minio** on ports `9000` and `9001`

The postgres image is built locally from the checked-in Dockerfile and tagged `foundation-postgres:18-pgvector-postgis` by default. Override `POSTGRES_IMAGE` in `compose/.env` only if you intentionally want to consume a published artifact instead.

## Environment variables

Copy `.env.example` to `.env` and adjust as needed:

```bash
cp compose/.env.example compose/.env
```

Default credentials:
- User: `postgres`
- Password: `postgres`
- Dev DB: `hominem`
- Test DB: `hominem-test`

## Health check

```bash
just health
```

## Migrations

This repo does not ship application migrations. Run migrations from the consuming app or service that owns its schema.

## Stop services

```bash
just down
```

## Reset everything

```bash
just kill
```

## Validate compose config

```bash
just validate-compose
```

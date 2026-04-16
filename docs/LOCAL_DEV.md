# Local development with foundation

## Prerequisites

- Docker
- [just](https://github.com/casey/just)
- Go (for goose migrations)

## Start local infrastructure

```bash
just docker-up
```

This starts:
- **postgres** on port `5434` (dev database)
- **postgres-test** on port `4433` (test database)
- **redis** on port `6379`

The postgres image is pulled from `ghcr.io/ponti-studios/hominem/postgres:latest`.

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
just health-check
```

## Run migrations

Set `DATABASE_URL` first, then:

```bash
DATABASE_URL=postgresql://postgres:postgres@localhost:5434/hominem just db-migrate
```

## Stop services

```bash
just docker-down
```

## Reset everything

```bash
just docker-kill
```

## Validate compose config

```bash
just validate-compose
```

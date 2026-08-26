# Local Development

`foundation` ships a self-contained local stack for PostgreSQL, Redis, MinIO,
OpenTelemetry Collector, and Jaeger.

## Start

```bash
just up
```

This starts:
- `postgres` on port `5434`
- `postgres-test` on port `4433`
- `redis` on port `6379`
- `minio` on ports `9000` and `9001`
- OTLP Collector on ports `4317` (gRPC) and `4318` (HTTP)
- Jaeger UI on port `16686`

The postgres image is built locally from the checked-in Dockerfile. If you need the published artifact for debugging, use the digest-pinned reference from [README.md](../README.md#images).

Local applications can export OTLP telemetry to `http://localhost:4318`. Open
Jaeger at http://localhost:16686. Collector logs are available with:

```bash
just logs otel-collector
```

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

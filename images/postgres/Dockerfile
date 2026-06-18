FROM pgvector/pgvector@sha256:42e7f6b4e1eceb02ff14e3e6bc6108bbe259abbe83879dc1845d0da1ddeb555d

LABEL org.opencontainers.image.description="PostgreSQL 18 with pgvector, PostGIS, and pgRouting"

RUN apt-get update && apt-get install -y --no-install-recommends \
    "postgresql-18-postgis-3=3.6.2*" \
    postgresql-18-pgrouting \
    && rm -rf /var/lib/apt/lists/*

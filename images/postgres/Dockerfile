FROM pgvector/pgvector@sha256:78bf48b801e792f99e3ac62b5036fd3876e9be48afda16c1e331af1c75ceb2ff

LABEL org.opencontainers.image.description="PostgreSQL 18 with pgvector 0.8.6, PostGIS 3.6.4, and pgRouting"

COPY initdb/ /docker-entrypoint-initdb.d/

RUN apt-get update && apt-get install -y --no-install-recommends \
    "postgresql-18-postgis-3=3.6.4*" \
    postgresql-18-pgrouting \
    && rm -rf /var/lib/apt/lists/*

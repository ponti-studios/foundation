#!/usr/bin/env just --justfile

set shell := ["bash", "-euo", "pipefail", "-c"]
set positional-arguments := true

ROOT_DIR := justfile_directory()

COMPOSE_FILES := "-f {{ ROOT_DIR }}/compose/base.yml -f {{ ROOT_DIR }}/compose/dev.yml"

goose-install goose-version="v3.27.0":
    #!/usr/bin/env bash
    goose_bin="$(go env GOPATH)/bin/goose"
    if [ ! -x "$goose_bin" ]; then
      go install github.com/pressly/goose/v3/cmd/goose@{{ goose-version }}
    fi
    export PATH="$(dirname "$goose_bin"):$PATH"
    if [ -n "${GITHUB_PATH:-}" ]; then
      echo "$(dirname "$goose_bin")" >> "$GITHUB_PATH"
    fi

db-migrate:
    #!/usr/bin/env bash
    just goose-install
    DATABASE_URL="${DATABASE_URL:-postgresql://postgres:postgres@127.0.0.1:5434/hominem}"
    goose -dir "{{ ROOT_DIR }}/compose" postgres "$DATABASE_URL" up

db-rollback:
    #!/usr/bin/env bash
    just goose-install
    DATABASE_URL="${DATABASE_URL:-postgresql://postgres:postgres@127.0.0.1:5434/hominem}"
    goose -dir "{{ ROOT_DIR }}/compose" postgres "$DATABASE_URL" down

db-status:
    #!/usr/bin/env bash
    just goose-install
    DATABASE_URL="${DATABASE_URL:-postgresql://postgres:postgres@127.0.0.1:5434/hominem}"
    goose -dir "{{ ROOT_DIR }}/compose" postgres "$DATABASE_URL" status

docker-up:
    docker compose {{ COMPOSE_FILES }} up -d

docker-down:
    docker compose {{ COMPOSE_FILES }} down

docker-kill:
    docker compose {{ COMPOSE_FILES }} down --rmi all --volumes --remove-orphans

docker-logs service="":
    docker compose {{ COMPOSE_FILES }} logs {{ service }}

health-check:
    #!/usr/bin/env bash
    for svc in db db-test redis; do
      if ! docker compose {{ COMPOSE_FILES }} ps $$svc | grep -q "Up"; then
        echo "Service $$svc is not running"
        exit 1
      fi
    done
    echo "All services healthy"

validate-compose:
    docker compose {{ COMPOSE_FILES }} config --quiet

.PHONY: docker-up docker-down docker-kill docker-logs health-check validate-compose

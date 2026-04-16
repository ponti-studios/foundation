#!/usr/bin/env just --justfile

set shell := ["bash", "-euo", "pipefail", "-c"]
set positional-arguments := true

ROOT_DIR := justfile_directory()

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

docker-up:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" up -d

docker-down:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" down

docker-kill:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" down --rmi all --volumes --remove-orphans

docker-logs service="":
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" logs {{ service }}

health-check:
    #!/usr/bin/env bash
    for svc in db db-test redis; do
      if ! docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" ps $$svc | grep -q "Up"; then
        echo "Service $$svc is not running"
        exit 1
      fi
    done
    echo "All services healthy"

validate-compose:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" config --quiet

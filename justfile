#!/usr/bin/env just --justfile

set shell := ["bash", "-euo", "pipefail", "-c"]
set positional-arguments

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

up:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" up -d

down:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" down

kill:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" down --rmi all --volumes --remove-orphans

logs service="":
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" logs {{ service }}

health:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" ps | grep -E "(db|redis)" | grep -v "Up" | grep -q "Exit" && echo "A service is down" && exit 1; echo "All services healthy"

validate-compose:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" config --quiet

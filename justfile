#!/usr/bin/env just --justfile

set shell := ["bash", "-euo", "pipefail", "-c"]
set positional-arguments

ROOT_DIR := justfile_directory()

up:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" up --build -d

down:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" down

kill:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" down --rmi all --volumes --remove-orphans

logs service="":
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" logs {{ service }}

health:
    for service in db db-test redis minio jaeger otel-collector; do if ! docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" ps --status running --services | grep -qx "$$service"; then echo "Service is not running: $$service"; exit 1; fi; done; echo "All services running"

validate-compose:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" config --quiet

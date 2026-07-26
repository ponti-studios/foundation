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
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" ps | grep -E "(db|redis|minio)" | grep -E "(Exit|unhealthy|starting)" && echo "A service is down" && exit 1; echo "All services healthy"

validate-compose:
    docker compose -f "{{ ROOT_DIR }}/compose/base.yml" -f "{{ ROOT_DIR }}/compose/dev.yml" config --quiet

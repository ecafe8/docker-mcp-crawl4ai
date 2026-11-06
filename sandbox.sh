#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="agent-infra-sandbox"
IMAGE="ghcr.io/agent-infra/sandbox:latest"
SANDBOX_PORT="${SANDBOX_PORT:-8080}"

case "${1:-start}" in
  start)
    if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
      docker update --restart unless-stopped "$CONTAINER_NAME"
      docker start "$CONTAINER_NAME"
    else
      docker run -d --restart unless-stopped -p "127.0.0.1:${SANDBOX_PORT}:8080" --name "$CONTAINER_NAME" \
        "$IMAGE"
    fi
    printf 'Sandbox is available at http://localhost:%s\n' "$SANDBOX_PORT"
    ;;
  stop)
    if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
      docker stop "$CONTAINER_NAME"
    else
      printf 'Container %s does not exist.\n' "$CONTAINER_NAME"
    fi
    ;;
  *)
    printf 'Usage: %s [start|stop]\n' "$0" >&2
    exit 2
    ;;
esac
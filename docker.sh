#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="crawl4ai"
IMAGE="unclecode/crawl4ai:latest"
CRAWL4AI_API_TOKEN="${CRAWL4AI_API_TOKEN:-benana}"

case "${1:-start}" in
  start)
    if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
      docker update --restart unless-stopped "$CONTAINER_NAME"
      docker start "$CONTAINER_NAME"
    else
      docker run -d --restart unless-stopped -p 11235:11235 --name "$CONTAINER_NAME" --shm-size=1g \
        -e CRAWL4AI_API_TOKEN="$CRAWL4AI_API_TOKEN" \
        "$IMAGE"
    fi
    printf 'Crawl4AI is available at http://localhost:11235\n'
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
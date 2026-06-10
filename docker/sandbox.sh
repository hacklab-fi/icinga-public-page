#!/usr/bin/env sh
#
# Hardened, disposable Docker sandbox for installing/building this repo without exposing
# the host.
#
# Usage:
#   docker/sandbox.sh build-image      # build the sandbox image
#   docker/sandbox.sh install          # npm ci (network ON) — scripts allowed
#   docker/sandbox.sh install:update   # npm install (network ON) — lets the lockfile change
#   docker/sandbox.sh audit            # npm audit (network ON)
#   docker/sandbox.sh build            # npm run build (network OFF)
#   docker/sandbox.sh lint             # npm run lint (network OFF)
#   docker/sandbox.sh dev              # vite dev server on http://127.0.0.1:5173 (network ON)
#   docker/sandbox.sh shell            # interactive shell (network OFF)
#   docker/sandbox.sh run <cmd...>     # arbitrary command (network OFF)
#
set -eu

IMAGE="icinga-sandbox:dev"
REPO="$(cd "$(dirname "$0")/.." && pwd)"

# Common hardening applied to every run:
#  - mount ONLY the repo, nothing else (no host home, no ssh keys, no docker socket)
#  - non-root, all Linux capabilities dropped, privilege escalation blocked
#  - read-only root filesystem; writable scratch is tmpfs only (gone when the container exits)
#  node_modules / dist land in the repo bind-mount, which is the only persistent write target.
hardening() {
  printf '%s\n' \
    --rm \
    --user node \
    --workdir /app \
    -v "$REPO":/app \
    --cap-drop ALL \
    --security-opt no-new-privileges \
    --read-only \
    --tmpfs /tmp:rw,nosuid,size=1g \
    --pids-limit 512 \
    --memory 2g \
    --cpus 2
}

run_net() {   # network ON  — for fetching from the registry
  # shellcheck disable=SC2046
  docker run $(hardening) "$IMAGE" "$@"
}

run_offline() {  # network OFF — install/build code cannot phone home or exfiltrate
  # shellcheck disable=SC2046
  docker run $(hardening) --network none "$IMAGE" "$@"
}

cmd="${1:-}"
[ $# -gt 0 ] && shift || true

case "$cmd" in
  build-image)
    docker build -f "$REPO/docker/Dockerfile.dev" -t "$IMAGE" "$REPO"
    ;;
  install)
    # Reproducible install from the lockfile. Lifecycle scripts run by design — they run
    # here, walled off from your keys, not on the host.
    run_net npm ci
    ;;
  install:update)
    run_net npm install   # allow lockfile changes (dependency bumps)
    ;;
  audit)
    run_net npm audit "$@"
    ;;
  build)
    run_offline npm run build
    ;;
  lint)
    run_offline npm run lint
    ;;
  dev)
    # Needs a network namespace to publish a port; bind to loopback only.
    # shellcheck disable=SC2046
    docker run $(hardening) -i -t -p 127.0.0.1:5173:5173 "$IMAGE" \
      npm run dev -- --host 0.0.0.0 --port 5173
    ;;
  shell)
    # shellcheck disable=SC2046
    docker run $(hardening) --network none -i -t "$IMAGE" bash
    ;;
  run)
    run_offline "$@"
    ;;
  *)
    sed -n '2,20p' "$0"
    exit 1
    ;;
esac

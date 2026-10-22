#!/usr/bin/env bash
set -e

# Cloudflare Pages Build Ignore Script
# Checks whether any files relevant to @novu/dashboard have changed.
# Exit 0 = Skip build (no relevant changes)
# Exit 1 = Proceed with build (changes detected)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

WATCHED_PATHS=(
  "apps/dashboard"
  "packages/shared"
  "packages/react"
  "packages/js"
  "packages/framework"
  "packages/api"
  "packages/maily-core"
  "pnpm-lock.yaml"
  "pnpm-workspace.yaml"
  "package.json"
)

# CF_PAGES_COMMIT_SHA and CACHED_COMMIT_REF are provided by Cloudflare Pages
COMMIT_SHA="${COMMIT_SHA:-${CF_PAGES_COMMIT_SHA:-HEAD}}"
BASE_REF="${BASE_REF:-${CACHED_COMMIT_REF:-HEAD^}}"

echo "Evaluating changes between ${BASE_REF} and ${COMMIT_SHA} for dashboard..."

if git diff --name-only "$BASE_REF" "$COMMIT_SHA" -- "${WATCHED_PATHS[@]}" | grep -q .; then
  echo "Dashboard-relevant changes detected. Proceeding with Cloudflare Pages build."
  exit 1
else
  echo "No dashboard-relevant changes detected. Skipping Cloudflare Pages build."
  exit 0
fi

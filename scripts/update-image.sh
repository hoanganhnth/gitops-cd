#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Script: update-image.sh
# Purpose: Automatically updates the image tag of a service in GitOps repo values.yaml
# Usage:
#   ./scripts/update-image.sh --service api-gateway --tag abc1234 --env staging
# ==============================================================================

SERVICE=""
TAG=""
ENV="staging"
AUTO_COMMIT="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --service|-s)
      SERVICE="$2"
      shift 2
      ;;
    --tag|-t)
      TAG="$2"
      shift 2
      ;;
    --env|-e)
      ENV="$2"
      shift 2
      ;;
    --commit|-c)
      AUTO_COMMIT="true"
      shift
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "$SERVICE" || -z "$TAG" ]]; then
  echo "Usage: $0 --service <service-name> --tag <new-tag> [--env staging|production] [--commit]" >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VALUES_FILE="${ROOT_DIR}/helm/environments/${ENV}/values.yaml"

if [[ ! -f "$VALUES_FILE" ]]; then
  echo "Error: Values file not found: $VALUES_FILE" >&2
  exit 1
fi

echo "Updating service '$SERVICE' to tag '$TAG' in $VALUES_FILE..."

python3 - <<PY
import sys
import re

service = "${SERVICE}"
tag = "${TAG}"
values_file = "${VALUES_FILE}"

with open(values_file, "r") as f:
    lines = f.readlines()

in_service = False
updated = False
new_lines = []

for line in lines:
    # Match root key: 'service-name:'
    if re.match(r"^" + re.escape(service) + r":\s*$", line):
        in_service = True
        new_lines.append(line)
        continue

    # If we hit another root key, we've left this service's section
    if in_service and re.match(r"^[a-zA-Z0-9_-]+:\s*$", line):
        in_service = False

    # Within service block, find 'tag: "..."'
    if in_service and not updated and re.match(r"^\s+tag:\s*.*$", line):
        indent = re.match(r"^(\s*)tag:", line).group(1)
        new_lines.append(f'{indent}tag: "{tag}"\n')
        updated = True
        continue

    new_lines.append(line)

if not updated:
    print(f"Warning: Service '{service}' or its image.tag not found in {values_file}. No changes made.")
    sys.exit(1)

with open(values_file, "w") as f:
    f.writelines(new_lines)

print(f"Successfully updated {service}.image.tag to '{tag}' in {values_file}")
PY

git -C "$ROOT_DIR" diff "$VALUES_FILE"

if [[ "$AUTO_COMMIT" == "true" ]]; then
  git -C "$ROOT_DIR" config user.name "GitOps Bot"
  git -C "$ROOT_DIR" config user.email "gitops-bot@delivery.local"
  git -C "$ROOT_DIR" add "$VALUES_FILE"
  git -C "$ROOT_DIR" commit -m "ci(deploy): update image tag for ${SERVICE} to ${TAG} in ${ENV} [skip ci]"
  echo "Committed update for ${SERVICE} (${TAG}) in ${ENV}."
fi

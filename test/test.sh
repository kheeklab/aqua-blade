#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$(mktemp)"

trap 'rm -f "${CONFIG_FILE}"' EXIT

cat >"${CONFIG_FILE}" <<EOF
registries:
  - name: local
    type: local
    path: ${ROOT_DIR}/registry.yaml

packages:
  - name: blade@v8.0.0.202602021941
    registry: local
EOF

export AQUA_CONFIG="${CONFIG_FILE}"
export AQUA_POLICY_CONFIG="${ROOT_DIR}/aqua-policy.yaml"
aqua policy allow "${ROOT_DIR}/aqua-policy.yaml"
aqua i -l
export PATH="${HOME}/.local/share/aquaproj-aqua/bin:${PATH}"
blade version

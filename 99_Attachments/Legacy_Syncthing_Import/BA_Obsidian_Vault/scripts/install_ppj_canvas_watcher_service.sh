#!/usr/bin/env bash
set -euo pipefail

# Installs (but never enables or starts) a user-level systemd unit.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
VAULT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
USER_CONFIG_ROOT="${XDG_CONFIG_HOME:-$(systemd-path user-configuration)}"
UNIT_DIR="${USER_CONFIG_ROOT}/systemd/user"
UNIT_PATH="${UNIT_DIR}/ppj-executive-canvas-watcher.service"

mkdir -p "${UNIT_DIR}"
tmp_unit="$(mktemp)"
trap 'rm -f "${tmp_unit}"' EXIT
sed \
  -e "s|@@VAULT_ROOT@@|${VAULT_ROOT}|g" \
  -e "s|@@PYTHON@@|$(command -v python3)|g" \
  "${SCRIPT_DIR}/ppj-executive-canvas-watcher.service.template" > "${tmp_unit}"
install -m 0644 "${tmp_unit}" "${UNIT_PATH}"
systemctl --user daemon-reload
printf 'Installed: %s\n' "${UNIT_PATH}"
printf 'The service was NOT enabled or started.\n'
printf 'Inspect: systemctl --user cat ppj-executive-canvas-watcher.service\n'
printf 'Start manually: systemctl --user start ppj-executive-canvas-watcher.service\n'

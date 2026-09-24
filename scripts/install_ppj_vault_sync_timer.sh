#!/usr/bin/env bash
set -euo pipefail

# Installs, enables and starts the user-level systemd timer for the vault git sync
# (Linux counterpart of Register-PPJVaultSyncTask.ps1, which also starts immediately).
# Re-run any time to redeploy after editing the templates.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
VAULT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
USER_CONFIG_ROOT="${XDG_CONFIG_HOME:-$(systemd-path user-configuration)}"
UNIT_DIR="${USER_CONFIG_ROOT}/systemd/user"

mkdir -p "${UNIT_DIR}"
tmp_unit="$(mktemp)"
trap 'rm -f "${tmp_unit}"' EXIT
for unit in ppj-vault-sync.service ppj-vault-sync.timer; do
  sed \
    -e "s|@@VAULT_ROOT@@|${VAULT_ROOT}|g" \
    -e "s|@@PYTHON@@|$(command -v python3)|g" \
    "${SCRIPT_DIR}/${unit}.template" > "${tmp_unit}"
  install -m 0644 "${tmp_unit}" "${UNIT_DIR}/${unit}"
  printf 'Installed: %s\n' "${UNIT_DIR}/${unit}"
done
systemctl --user daemon-reload
systemctl --user enable --now ppj-vault-sync.timer
printf 'ENABLED and STARTED: ppj-vault-sync.timer (every 3h at :20 past - 00:20/03:20/06:20/.../21:20, Persistent=true)\n'
printf 'Next run:  systemctl --user list-timers ppj-vault-sync.timer\n'
printf 'Run now:   systemctl --user start ppj-vault-sync.service\n'
printf 'Log:       %s/.git/vault-sync.log  (or: journalctl --user -u ppj-vault-sync.service)\n' "${VAULT_ROOT}"
printf 'Disable:   systemctl --user disable --now ppj-vault-sync.timer\n'

#!/usr/bin/env zsh
# Installs common Neovim healthcheck dependencies on Void Linux.
# Safe to run multiple times; skips already-installed packages.

set -euo pipefail

if ! command -v xbps-install >/dev/null 2>&1; then
  echo "This script is intended for Void Linux (xbps-install not found)." >&2
  exit 1
fi

echo "[*] Updating repository indexes..."
sudo xbps-install -Sy

# Core CLI tools frequently required by plugins/healthchecks
CORE=(
  git
  ripgrep        # rg for telescope/grep
  fd             # fd for telescope
  xclip          # clipboard provider
  tree-sitter    # CLI to remove nvim-treesitter warning
)

# Language toolchains used by mason, treesitter build, LSPs, etc.
LANG=(
  gcc
  make
  nodejs
  npm
  python3
  python3-pip
  go
  rust           # provides cargo as well
  luarocks
)

# Optional: clear mason language warnings (install if you plan to use them)
OPTIONAL=(
  php
  composer
  julia
)

echo "[*] Installing core tools: ${CORE[*]}"
sudo xbps-install -y ${=CORE}

echo "[*] Installing language toolchains: ${LANG[*]}"
sudo xbps-install -y ${=LANG}

echo "[*] Installing optional extras (can be skipped safely): ${OPTIONAL[*]}"
sudo xbps-install -y ${=OPTIONAL} || true

echo "[✓] Done. You can re-run Neovim healthchecks now."


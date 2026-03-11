#!/usr/bin/env bash
# Cross-distro installer for Neovim and common dependencies
# Supports: Void Linux and Ubuntu 22.04 LTS
# Safe to run multiple times; skips already-installed packages.
#
# Usage:
#   ./setup.sh           # installs required packages only
#   ./setup.sh --all     # installs required + optional extras
#   ./setup.sh -h|--help # show help

set -euo pipefail

is_cmd() { command -v "$1" >/dev/null 2>&1; }

log()  { printf '%s\n' "$*"; }
note() { log "[*] $*"; }
ok()   { log "[✓] $*"; }
warn() { log "[!] $*"; }
same() { log "[=] $*"; }

INCLUDE_OPTIONAL=false
print_help() {
  cat <<EOF
Usage: $0 [--all]

Installs Neovim and required dependencies for this config.

Options:
  --all     Include optional extras (php, composer, juliaup, etc.)
  -h, --help  Show this help and exit
EOF
}

case "${1:-}" in
  --all|all|-a)
    INCLUDE_OPTIONAL=true
    ;;
  -h|--help)
    print_help
    exit 0
    ;;
  "") ;;
  *)
    warn "Unknown option: $1"
    print_help
    exit 2
    ;;
esac

# ------------------------------
# Void Linux (xbps)
# ------------------------------
ensure_pkg_xbps() {
  local pkg="$1"
  if xbps-query -i "$pkg" >/dev/null 2>&1; then
    same "$pkg already installed"
  else
    note "Installing $pkg"
    sudo xbps-install -y "$pkg"
  fi
}

install_void() {
  note "Updating repository indexes (xbps)"
  sudo xbps-install -Sy

  # Core CLI tools
  local core=(git ripgrep fd xclip)
  # Languages and build toolchains
  local langs=(gcc make nodejs python3 python3-pip go rust luarocks)
  # Optional extras
  local optional=(php composer juliaup)

  note "Ensuring Neovim"
  ensure_pkg_xbps neovim

  note "Ensuring core tools"
  for p in "${core[@]}"; do ensure_pkg_xbps "$p"; done

  note "Ensuring language toolchains"
  for p in "${langs[@]}"; do ensure_pkg_xbps "$p"; done

  note "Ensuring optional extras (safe to skip)"
  if $INCLUDE_OPTIONAL; then
    for p in "${optional[@]}"; do ensure_pkg_xbps "$p" || true; done
  else
    same "Skipping optional extras (pass --all to include)"
  fi

  ensure_tree_sitter_cli_void || true
  if $INCLUDE_OPTIONAL; then ensure_julia_via_juliaup || true; fi

  ok "Void setup complete"
}

ensure_tree_sitter_cli_void() {
  if is_cmd tree-sitter; then same "tree-sitter CLI already available"; return 0; fi
  note "Attempting to install tree-sitter CLI via xbps"
  if ensure_pkg_xbps tree-sitter-cli 2>/dev/null; then
    is_cmd tree-sitter && { ok "tree-sitter CLI installed"; return 0; }
  fi
  if ensure_pkg_xbps tree-sitter 2>/dev/null; then
    is_cmd tree-sitter && { ok "tree-sitter CLI installed (tree-sitter)"; return 0; }
  fi
  # Try cargo fallback (usually most reliable)
  if is_cmd cargo; then
    note "Installing tree-sitter-cli via cargo"
    cargo install tree-sitter-cli --locked || true
    if [ -x "$HOME/.cargo/bin/tree-sitter" ]; then
      note "Linking $HOME/.cargo/bin/tree-sitter to /usr/local/bin/tree-sitter"
      sudo ln -sf "$HOME/.cargo/bin/tree-sitter" /usr/local/bin/tree-sitter || true
    fi
    is_cmd tree-sitter && { ok "tree-sitter CLI available (cargo)"; return 0; }
  fi
  note "Falling back to npm global install for tree-sitter-cli"
  if is_cmd npm; then
    sudo npm -g install tree-sitter-cli || true
    local npm_bin
    npm_bin=$(npm bin -g 2>/dev/null || true)
    if [ -n "${npm_bin:-}" ] && [ -x "$npm_bin/tree-sitter" ]; then
      note "Linking $npm_bin/tree-sitter to /usr/local/bin/tree-sitter"
      sudo ln -sf "$npm_bin/tree-sitter" /usr/local/bin/tree-sitter || true
    fi
  else
    warn "npm not found; install nodejs/npm to get tree-sitter-cli via npm"
  fi
  is_cmd tree-sitter && { ok "tree-sitter CLI available"; return 0; }
  warn "Could not ensure tree-sitter CLI; consider adding npm global bin to PATH or installing from repos"
  return 1
}

# ------------------------------
# Ubuntu 22.04 (apt)
# ------------------------------
ensure_pkg_apt() {
  local pkg="$1"
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    same "$pkg already installed"
  else
    note "Installing $pkg"
    sudo apt-get install -y "$pkg"
  fi
}

ensure_neovim_ubuntu() {
  if is_cmd nvim; then same "Neovim already installed"; return 0; fi
  # Prefer upstream stable PPA for a newer Neovim on 22.04
  if ! is_cmd add-apt-repository; then
    sudo apt-get install -y software-properties-common
  fi
  note "Adding Neovim stable PPA (neovim-ppa/stable)"
  sudo add-apt-repository -y ppa:neovim-ppa/stable || true
  sudo apt-get update -y
  sudo apt-get install -y neovim
}

ensure_tree_sitter_cli_ubuntu() {
  if is_cmd tree-sitter; then same "tree-sitter CLI already available"; return 0; fi
  # Try apt first; ignore failure on older repos
  sudo apt-get install -y tree-sitter-cli || true
  is_cmd tree-sitter && { ok "tree-sitter CLI installed via apt"; return 0; }
  sudo apt-get install -y tree-sitter || true
  is_cmd tree-sitter && { ok "tree-sitter CLI available (tree-sitter)"; return 0; }
  # Prefer cargo fallback to avoid node version issues on 22.04
  if is_cmd cargo; then
    note "Installing tree-sitter-cli via cargo"
    cargo install tree-sitter-cli --locked || true
    if [ -x "$HOME/.cargo/bin/tree-sitter" ]; then
      note "Linking $HOME/.cargo/bin/tree-sitter to /usr/local/bin/tree-sitter"
      sudo ln -sf "$HOME/.cargo/bin/tree-sitter" /usr/local/bin/tree-sitter || true
    fi
    is_cmd tree-sitter && { ok "tree-sitter CLI available (cargo)"; return 0; }
  else
    warn "cargo not found; install Rust toolchain to build tree-sitter-cli"
  fi
  note "Falling back to npm global install for tree-sitter-cli"
  if is_cmd npm; then
    sudo npm -g install tree-sitter-cli || true
    local npm_bin
    npm_bin=$(npm bin -g 2>/dev/null || true)
    if [ -n "${npm_bin:-}" ] && [ -x "$npm_bin/tree-sitter" ]; then
      note "Linking $npm_bin/tree-sitter to /usr/local/bin/tree-sitter"
      sudo ln -sf "$npm_bin/tree-sitter" /usr/local/bin/tree-sitter || true
    fi
  else
    warn "npm not found; install nodejs and npm to get tree-sitter-cli via npm"
  fi
  is_cmd tree-sitter && { ok "tree-sitter CLI available"; return 0; }
  warn "Could not ensure tree-sitter CLI"
  return 1
}

ensure_fd_symlink_ubuntu() {
  # Ubuntu binary is fdfind; many tools expect fd
  if is_cmd fd; then return 0; fi
  if is_cmd fdfind; then
    note "Linking fdfind to /usr/local/bin/fd"
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd || true
  fi
}

install_ubuntu_2204() {
  note "Updating apt indexes"
  sudo apt-get update -y

  ensure_neovim_ubuntu

  # Core tools
  local core=(git ripgrep fd-find xclip curl unzip)
  for p in "${core[@]}"; do ensure_pkg_apt "$p"; done
  ensure_fd_symlink_ubuntu || true

  # Languages and build toolchains
  local langs=(build-essential make nodejs npm python3 python3-pip golang-go rustc cargo luarocks)
  for p in "${langs[@]}"; do ensure_pkg_apt "$p"; done

  # Optional extras
  local optional=(php composer)
  if $INCLUDE_OPTIONAL; then
    for p in "${optional[@]}"; do ensure_pkg_apt "$p" || true; done
  else
    same "Skipping optional extras (pass --all to include)"
  fi

  ensure_tree_sitter_cli_ubuntu || true
  if $INCLUDE_OPTIONAL; then ensure_julia_via_juliaup || true; fi

  ok "Ubuntu 22.04 setup complete"
}

# ------------------------------
# Shared helpers
# ------------------------------
ensure_julia_via_juliaup() {
  if is_cmd julia; then same "julia already available"; return 0; fi
  if ! is_cmd juliaup; then
    warn "juliaup not found; install 'julia' or 'juliaup' if needed (optional)"
    return 0
  fi
  note "Installing Julia 'release' channel via juliaup"
  juliaup self update >/dev/null 2>&1 || true
  juliaup add release >/dev/null 2>&1 || true
  juliaup default release >/dev/null 2>&1 || true
  local shim="$HOME/.juliaup/bin/julia"
  if [ -x "$shim" ] && ! is_cmd julia; then
    note "Linking $shim to /usr/local/bin/julia"
    sudo ln -sf "$shim" /usr/local/bin/julia || true
  fi
  is_cmd julia && ok "julia available via juliaup" || warn "julia not on PATH; add \"$HOME/.juliaup/bin\" or link the shim"
}

# ------------------------------
# Entrypoint
# ------------------------------
main() {
  if is_cmd xbps-install; then
    install_void
    ok "Done. You can run Neovim healthchecks now."
    return 0
  fi

  # Detect Ubuntu 22.04 specifically
  if [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    if [ "${ID:-}" = "ubuntu" ] && [ "${VERSION_ID:-}" = "22.04" ]; then
      install_ubuntu_2204
      ok "Done. You can run Neovim healthchecks now."
      return 0
    fi
  fi

  warn "Unsupported distro. This script supports Void Linux and Ubuntu 22.04."
  warn "You can adapt the package names to your distro."
  exit 1
}

main "$@"

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
)

# Language toolchains used by mason, treesitter build, LSPs, etc.
LANG_PKGS=(
    gcc
    make
    nodejs
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
    juliaup
)

ensure_pkg() {
    local pkg="$1"
    if xbps-query -i "$pkg" >/dev/null 2>&1; then
        echo "[=] $pkg already installed"
    else
        echo "[+] Installing $pkg"
        sudo xbps-install -y "$pkg"
    fi
}

echo "[*] Ensuring core tools..."
for p in ${CORE[@]}; do ensure_pkg "$p"; done

echo "[*] Ensuring language toolchains..."
for p in ${LANG_PKGS[@]}; do ensure_pkg "$p"; done

echo "[*] Ensuring optional extras (safe to skip)..."
for p in ${OPTIONAL[@]}; do ensure_pkg "$p" || true; done

# Ensure Julia is available via juliaup (similar to rustup)
ensure_julia_via_juliaup() {
    if command -v julia >/dev/null 2>&1; then
        echo "[=] julia already available"
        return 0
    fi
    if ! command -v juliaup >/dev/null 2>&1; then
        echo "[!] juliaup not found; install the 'juliaup' package to manage Julia versions."
        return 0
    fi

    echo "[*] Installing Julia 'release' channel via juliaup..."
    # Update juliaup (non-fatal if it fails) and install default channel
    juliaup self update >/dev/null 2>&1 || true
    juliaup add release >/dev/null 2>&1 || true
    juliaup default release >/dev/null 2>&1 || true

    # Try to make the shim reachable
    local shim="$HOME/.juliaup/bin/julia"
    if [ -x "$shim" ]; then
        # Create a global symlink if julia still not resolved
        if ! command -v julia >/dev/null 2>&1; then
            echo "[*] Linking $shim to /usr/local/bin/julia"
            sudo ln -sf "$shim" /usr/local/bin/julia || true
        fi
    fi

    if command -v julia >/dev/null 2>&1; then
        echo "[✓] julia available via juliaup"
    else
        echo "[!] julia not on PATH. Add $HOME/.juliaup/bin to your PATH or create a symlink to $shim."
    fi
}

# Ensure tree-sitter CLI is available in PATH
ensure_tree_sitter_cli() {
    if command -v tree-sitter >/dev/null 2>&1; then
        echo "[=] tree-sitter CLI already available"
        return 0
    fi
    echo "[*] Attempting to install tree-sitter CLI via xbps..."
    if ensure_pkg tree-sitter-cli 2>/dev/null; then
        if command -v tree-sitter >/dev/null 2>&1; then
            echo "[✓] tree-sitter CLI installed via xbps"
            return 0
        fi
    fi
    # Some repositories ship CLI under the 'tree-sitter' package
    if ensure_pkg tree-sitter 2>/dev/null; then
        if command -v tree-sitter >/dev/null 2>&1; then
            echo "[✓] tree-sitter CLI installed via xbps (tree-sitter)"
            return 0
        fi
    fi
    echo "[*] Falling back to npm global install for tree-sitter-cli..."
    if command -v npm >/dev/null 2>&1; then
        sudo npm -g install tree-sitter-cli || true
        local npm_bin
        npm_bin=$(npm bin -g 2>/dev/null || true)
        if [ -n "$npm_bin" ] && [ -x "$npm_bin/tree-sitter" ]; then
            echo "[*] Linking $npm_bin/tree-sitter to /usr/local/bin/tree-sitter"
            sudo ln -sf "$npm_bin/tree-sitter" /usr/local/bin/tree-sitter || true
        fi
    else
        echo "[!] npm not found; installed nodejs typically provides npm on Void. Ensure npm is available to install tree-sitter-cli."
    fi
    if command -v tree-sitter >/dev/null 2>&1; then
        echo "[✓] tree-sitter CLI available"
        return 0
    fi
    echo "[!] Could not ensure tree-sitter CLI. You may need to add npm global bin to PATH or install tree-sitter-cli from repos."
    return 1
}

ensure_tree_sitter_cli || true

# Ensure Julia availability at the end (non-fatal if it fails)
ensure_julia_via_juliaup || true

echo "[✓] Done. You can re-run Neovim healthchecks now."

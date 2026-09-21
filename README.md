# Neovim Setup — System Requirements

This configuration uses several Neovim plugins that depend on external tools and runtimes. Install the following on your OS so everything works smoothly.

## Core CLI/build tools
- git: required for plugin installation via lazy.nvim
- make: used by multiple plugins for build steps
- C/C++ toolchain: gcc or clang (required for nvim-treesitter parsers and some plugin builds)

## Required language runtimes
- Node.js (LTS or newer): required by JavaScript-based language servers, linters, and formatters
- Python 3: used by `nvim-dap-python`/`debugpy` and `neotest-python`; recommended to have `pip` and virtualenv available
- Rust toolchain (`rustup`, `cargo`): required by `rustaceanvim` / rust-analyzer workflow
- Flutter SDK + Dart: required by `flutter-tools.nvim`

## CLI tools used directly in the config
- ripgrep (`rg`): used by Telescope live_grep
- fd (optional but recommended): used by Telescope find_files for speed
- lazygit (optional but mapped): used by ToggleTerm integration (`:LazyGitToggle`)
- lazydocker (optional but mapped): used by ToggleTerm integration (`:LazyDockerToggle`)
- Claude Code or Codex CLI (optional): used by Sidekick's editor-aware AI terminal integration
- Docker (or Podman): required by `nvim-dev-container` to work with Dev Containers
- sshfs: required to mount remote workspaces with `remote-sshfs.nvim`
- termaid (optional): renders Mermaid diagrams in the `-cd` preview; install with `uv tool install termaid`

## Managed automatically by Mason
Mason will install and manage the following developer tools on demand (no need to preinstall globally):

- LSP servers: `lua-language-server`, `typescript-language-server`, `yaml-language-server`, `marksman`,
  `basedpyright`, `ruff`, `taplo`, `bash-language-server`, `dockerfile-language-server`,
  `vue-language-server`, `rust-analyzer`
- DAP: `codelldb`, `debugpy`
- Linters: `markdownlint`, `yamllint`
- Formatters: `prettier`, `stylua`, `beautysh`, `shfmt`, `isort`, `black`, `yamlfmt`, `dcm`

Mason installs binaries into Neovim’s data directory; no system-wide installation is required for these.

## Shared devtool defaults

Formatter and linter defaults are read from `$DEVTOOLS_CONFIG_HOME`, defaulting to `$XDG_CONFIG_HOME/devtools`
or `~/.config/devtools`:

- `ruff.toml`
- `yamllint.yaml`
- `markdownlint.yaml`
- `stylua.toml`
- `prettier.json`

Project-local configuration files take precedence. Set `DEVTOOLS_CONFIG_HOME` to use a different central directory.
Ruff diagnostics are provided by Ruff LSP; nvim-lint is reserved for tools without an active LSP integration.

## Plugin-specific notes
- Sidekick: `-ac` opens Claude, `-ax` opens Codex, and `-as` selects another installed CLI.
- Terminal escape layer: a running TUI (claude, codex, lazygit, a shell) receives every key, so `-` and the
  leader mappings are invisible while the cursor is in terminal mode. These `t`-mode mappings stay with Neovim:
  - `Ctrl-t` / `Alt-t`: hand the keyboard to Neovim (normal mode). In a terminal buffer `Ctrl-t` toggles:
    press it again in normal mode to give the keyboard back to the running program. Outside a terminal it
    still opens a new tab.
  - `Alt--`: enter normal mode and start a leader mapping in one press (which-key pops up).
  - `Alt-Left/Down/Up/Right`: jump straight to the window in that direction.
  - `Alt-w`: acts as the `Ctrl-w` window prefix, e.g. `Alt-w` `v` splits, `Alt-w` `q` closes.
  - `Alt-J` / `Alt-K`: previous/next tab, mirroring `Shift-j` / `Shift-k` in normal mode.
- Clipboard history: `-sr` opens the current session's yank history. History intentionally stays in memory so copied
  credentials are not persisted to disk.
- Git review: `-go` opens the repository diff, while `]h` and `[h` move between hunks in a file.
- Mermaid: `-cd` previews the diagram under the cursor when `termaid` is installed.
- Remote SSH: `-mrc` connects to a host from your SSH config; run `:checkhealth remote-sshfs` to verify system tools.
- Treesitter: compiling parsers requires a working C toolchain (`gcc`/`clang`) and `make`.
- Python DAP FastAPI example: a sample DAP configuration launches `uvicorn` via `python -m uvicorn app.main:app --reload`. Ensure `uvicorn` is installed in your project’s environment if you use that command.

## Quick install hints

Ubuntu/Debian
- One-shot (Ubuntu 22.04): run `./setup.sh` (installs Neovim 0.11.x, modern Node 20.x + npm, rg/fd, etc.)
- Core tooling (manual): `sudo apt update && sudo apt install -y git build-essential ripgrep fd-find python3 python3-venv docker.io make gcc sshfs`
- Node.js: prefer 18+ (20 LTS recommended). On Ubuntu, install via NodeSource:
  - `sudo apt install -y ca-certificates curl gnupg`
  - `curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -`
  - `sudo apt-get install -y nodejs`
- Optional TUI tools: `sudo apt install -y lazygit` (lazydocker: install per upstream)
- Rust toolchain: `curl https://sh.rustup.rs -sSf | sh`
- Flutter SDK + Dart: install from official docs (https://docs.flutter.dev/get-started/install) or snap (`sudo snap install flutter --classic`) and run `flutter doctor`.
- fd note: the binary is `fdfind` on Debian/Ubuntu. If you want `fd` in PATH: `mkdir -p ~/.local/bin && ln -s $(command -v fdfind) ~/.local/bin/fd` and add `~/.local/bin` to PATH.
- Docker post-install: add your user to the docker group and (optionally) enable on boot: `sudo usermod -aG docker $USER && sudo systemctl enable --now docker`

Void Linux
- Core tooling: `sudo xbps-install -S git base-devel ripgrep fd python3 python3-virtualenv nodejs docker gcc make fuse-sshfs`
- Optional TUI tools: `sudo xbps-install -S lazygit` (lazydocker: install per upstream)
- Rust toolchain: `curl https://sh.rustup.rs -sSf | sh`
- Flutter SDK + Dart: install from official docs (https://docs.flutter.dev/get-started/install); ensure `flutter` and `dart` are in PATH.
- Docker post-install (runit): `sudo ln -s /etc/sv/docker /var/service && sudo usermod -aG docker $USER`

Notes
- lazydocker install: follow https://github.com/jesseduffield/lazydocker (releases or script) if your repo doesn’t provide it.
- Uvicorn for the sample Python DAP config: install in your project env if you use that example, e.g., `pip install uvicorn`.

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
- Deno: required to build `peek.nvim` (`deno task --quiet build:fast`)

## CLI tools used directly in the config
- ripgrep (`rg`): used by Telescope live_grep
- fd (optional but recommended): used by Telescope find_files for speed
- lazygit (optional but mapped): used by ToggleTerm integration (`:LazyGitToggle`)
- lazydocker (optional but mapped): used by ToggleTerm integration (`:LazyDockerToggle`)
- Claude Code or Codex CLI (optional): used by Sidekick's editor-aware AI terminal integration
- Docker (or Podman): required by `nvim-dev-container` to work with Dev Containers

## Managed automatically by Mason
Mason will install and manage the following developer tools on demand (no need to preinstall globally):

- LSP servers: `lua-language-server`, `typescript-language-server`, `yaml-language-server`, `marksman`,
  `basedpyright`, `ruff`, `taplo`, `bash-language-server`, `dockerfile-language-server`,
  `vue-language-server`, `rust-analyzer`
- DAP: `codelldb`, `debugpy`
- Linters: `flake8`, `pyproject-flake8`, `eslint_d`, `markdownlint`, `yamllint`, `selene`
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
- Sidekick: `-ac` opens Claude, `-ax` opens Codex, and `-as` selects another installed CLI. Use `Ctrl-t`
  in a terminal to enter Neovim normal mode; the regular `-` leader mappings are then available.
- Clipboard history: `-sr` opens the current session's yank history. History intentionally stays in memory so copied
  credentials are not persisted to disk.
- Git review: `-go` opens the repository diff, while `]h` and `[h` move between hunks in a file.
- Treesitter: compiling parsers requires a working C toolchain (`gcc`/`clang`) and `make`.
- Peek (Markdown preview): requires `deno` to be installed and available in PATH.
- Python DAP FastAPI example: a sample DAP configuration launches `uvicorn` via `python -m uvicorn app.main:app --reload`. Ensure `uvicorn` is installed in your project’s environment if you use that command.

## Quick install hints

Ubuntu/Debian
- One-shot (Ubuntu 22.04): run `./setup.sh` (installs Neovim 0.11.x, modern Node 20.x + npm, rg/fd, etc.)
- Core tooling (manual): `sudo apt update && sudo apt install -y git build-essential ripgrep fd-find python3 python3-venv docker.io make gcc`
- Node.js: prefer 18+ (20 LTS recommended). On Ubuntu, install via NodeSource:
  - `sudo apt install -y ca-certificates curl gnupg`
  - `curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -`
  - `sudo apt-get install -y nodejs`
- Optional TUI tools: `sudo apt install -y lazygit` (lazydocker: install per upstream)
- Deno (for Peek): `sudo snap install deno --classic` or use the official script: `curl -fsSL https://deno.land/x/install/install.sh | sh`
- Rust toolchain: `curl https://sh.rustup.rs -sSf | sh`
- Flutter SDK + Dart: install from official docs (https://docs.flutter.dev/get-started/install) or snap (`sudo snap install flutter --classic`) and run `flutter doctor`.
- fd note: the binary is `fdfind` on Debian/Ubuntu. If you want `fd` in PATH: `mkdir -p ~/.local/bin && ln -s $(command -v fdfind) ~/.local/bin/fd` and add `~/.local/bin` to PATH.
- Docker post-install: add your user to the docker group and (optionally) enable on boot: `sudo usermod -aG docker $USER && sudo systemctl enable --now docker`

Void Linux
- Core tooling: `sudo xbps-install -S git base-devel ripgrep fd python3 python3-virtualenv nodejs docker gcc make`
- Optional TUI tools: `sudo xbps-install -S lazygit` (lazydocker: install per upstream)
- Deno (for Peek): `sudo xbps-install -S deno`
- Rust toolchain: `curl https://sh.rustup.rs -sSf | sh`
- Flutter SDK + Dart: install from official docs (https://docs.flutter.dev/get-started/install); ensure `flutter` and `dart` are in PATH.
- Docker post-install (runit): `sudo ln -s /etc/sv/docker /var/service && sudo usermod -aG docker $USER`

Notes
- lazydocker install: follow https://github.com/jesseduffield/lazydocker (releases or script) if your repo doesn’t provide it.
- Uvicorn for the sample Python DAP config: install in your project env if you use that example, e.g., `pip install uvicorn`.

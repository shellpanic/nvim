# Neovim development setup

This is a Neovim 0.11+ configuration with LSP, completion, formatting, linting,
debugging, a resource-bounded test UI, Markdown tooling, terminals, and Codex.

## Core CLI/build tools
- git: required for plugin installation via lazy.nvim
- make: used by multiple plugins for build steps
- C/C++ toolchain: gcc or clang (required for nvim-treesitter parsers and some plugin builds)

## Required language runtimes
- Node.js (LTS or newer): required by language tooling
- Python 3: used by `nvim-dap-python`/`debugpy` and `neotest-python`; recommended to have `pip` and virtualenv available
- Rust toolchain (`rustup`, `cargo`): required by `rustaceanvim` / rust-analyzer workflow
- Flutter SDK + Dart: required by `flutter-tools.nvim`
- Deno: required to build `peek.nvim` (`deno task --quiet build:fast`)

## CLI tools used directly in the config
- ripgrep (`rg`): used by Telescope live_grep
- fd (optional but recommended): used by Telescope find_files for speed
- lazygit (optional but mapped): used by ToggleTerm integration (`:LazyGitToggle`)
- lazydocker (optional but mapped): used by ToggleTerm integration (`:LazyDockerToggle`)
- Docker (or Podman): required by `nvim-dev-container` to work with Dev Containers

## Testing and debugging

Neotest supports Python and Rust. It is intentionally configured to avoid the
process storms that project discovery and watch mode can cause:

- automatic project-wide discovery is disabled;
- on-demand discovery uses one worker;
- test commands run sequentially;
- persistent watch mode is disabled;
- the summary animation is disabled.

The leader key is `-`. Useful test mappings are:

- `-un`: run the nearest test
- `-uf`: run the current file
- `-ur`: rerun the last test
- `-us`: toggle the test summary UI
- `-uo` / `-up`: open test output / toggle the output panel
- `-uS`: select a running test to stop
- `-ud` / `-uD`: debug the nearest test / current file

DAP UI opens automatically for debugger sessions and can be toggled with
`-du`. `F3` terminates the session; `F5`, `F10`, `F11`, and `F12` control it.

## AI

[`codex.nvim`](https://github.com/johnseth97/codex.nvim) provides a popup for
the installed Codex CLI. Toggle it with `-ax`. API credentials remain outside
this repository.

## Managed automatically by Mason

Mason installs and manages the following developer tools:

- LSP servers: Lua, TypeScript, YAML, Markdown, Python, TOML, Bash, Docker,
  Vue, and Rust servers
- DAP: `codelldb`, `debugpy`
- Linters/tools: `flake8`, `pyproject-flake8`, `eslint_d`, `markdownlint`,
  `yamllint`, `selene`, `ast-grep`
- Formatters: `prettier`, `stylua`, `beautysh`, `shfmt`, `isort`, `black`,
  `yamlfmt`, `taplo`, `dcm`

Mason installs binaries into Neovim’s data directory; no system-wide installation is required for these.

## Plugin-specific notes
- Treesitter: compiling parsers requires a working C toolchain (`gcc`/`clang`) and `make`.
- Peek (Markdown preview): requires `deno` to be installed and available in PATH.
- Python DAP FastAPI example: a sample DAP configuration launches `uvicorn`
  via `python -m uvicorn app.main:app`. Ensure `uvicorn` is installed in the
  project environment if you use it.

## Quick install hints

Ubuntu/Debian
- One-shot (Ubuntu 22.04): run `./setup.sh` (installs Neovim 0.11+, modern Node, Deno, rg/fd, etc.)
- Core tooling (manual): `sudo apt update && sudo apt install -y git build-essential ripgrep fd-find python3 python3-venv docker.io make gcc`
- Node.js: prefer 18+ (20 LTS recommended). On Ubuntu, install via NodeSource:
  - `sudo apt install -y ca-certificates curl gnupg`
  - `curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -`
  - `sudo apt-get install -y nodejs`
- Optional TUI tools: `sudo apt install -y lazygit` (lazydocker: install per upstream)
- Deno (for Peek) is installed by `setup.sh`; manually, use `curl -fsSL https://deno.land/install.sh | sh`
- Rust toolchain: `curl https://sh.rustup.rs -sSf | sh`
- Flutter SDK + Dart: install from official docs (https://docs.flutter.dev/get-started/install) or snap (`sudo snap install flutter --classic`) and run `flutter doctor`.
- fd note: the binary is `fdfind` on Debian/Ubuntu. If you want `fd` in PATH: `mkdir -p ~/.local/bin && ln -s $(command -v fdfind) ~/.local/bin/fd` and add `~/.local/bin` to PATH.
- Docker post-install: add your user to the docker group and (optionally) enable on boot: `sudo usermod -aG docker $USER && sudo systemctl enable --now docker`

Void Linux
- Core tooling: `sudo xbps-install -S git base-devel ripgrep fd python3 python3-virtualenv nodejs docker gcc make`
- Optional TUI tools: `sudo xbps-install -S lazygit` (lazydocker: install per upstream)
- Deno (for Peek) is installed by `setup.sh`; manually, use `sudo xbps-install -S deno`
- Rust toolchain: `curl https://sh.rustup.rs -sSf | sh`
- Flutter SDK + Dart: install from official docs (https://docs.flutter.dev/get-started/install); ensure `flutter` and `dart` are in PATH.
- Docker post-install (runit): `sudo ln -s /etc/sv/docker /var/service && sudo usermod -aG docker $USER`

Notes
- lazydocker install: follow https://github.com/jesseduffield/lazydocker (releases or script) if your repo doesn’t provide it.
- Uvicorn for the sample Python DAP config: install in your project env if you use that example, e.g., `pip install uvicorn`.

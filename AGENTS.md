# Repository Guidelines

## Project Structure & Module Organization
- Entry point: `init.lua` loads core settings, keymaps, and plugins.
- Core modules: `lua/settings.lua` (options) and `lua/keymap.lua` (global mappings).
- Leader key: `-` (set in `lua/settings.lua`).
- Plugins: `lua/plugins.lua` declares plugin specs (lazy.nvim). Lockfile: `lazy-lock.json`.
- Domain layout: plugin specs live under `lua/plugins/<domain>/*.lua` (e.g. `ui`, `editor`, `lsp`, `dap`, `testing`, `markdown`, `ai`, `misc`).
- Side‑effect keymaps: `init.lua` eagerly requires `lua/plugins/<domain>/keymaps.lua` so domain shortcuts are always available.
- Per‑plugin setup may live alongside the spec or in `lua/plug-config/<plugin>.lua` if shared across domains.

Eager UI modules (load at startup):
- `lua/plugins/ui/rigel.lua` (theme/colorscheme)
- `lua/plugins/ui/devicons.lua` (nvim‑web‑devicons)
- `lua/plugins/ui/lualine.lua` (statusline)
- `lua/plugins/ui/dressing.lua` (UI prompts)
- `lua/plugins/ui/indent.lua` (indent guides)

## Build, Test, and Development Commands
- Format: `stylua .` formats Lua files using `.stylua.toml`.
- Format check (CI): `stylua --check .` fails on unformatted code.
- Health check: `nvim +checkhealth` opens Neovim health report.
- Sync plugins: `nvim --headless +"Lazy! sync" +qa` installs/updates via lazy.nvim.
- Minimal load: `nvim --clean -u init.lua` starts with this config only (good for debugging).
- Eager UI: core UI is not lazy to guarantee startup experience (theme/colorscheme, devicons, statusline, dressing).

## Coding Style & Naming Conventions
- Language: Lua. Indent with 3 spaces (per `.stylua.toml`).
- Files: use lowercase with dashes or underscores, e.g., `lua/plug-config/telescope.lua`.
- Modules: prefer clear, single‑purpose files; avoid long `init.lua` blocks.
- Formatting: run `stylua` before commits; keep diffs minimal and focused.

## Testing Guidelines
- No formal unit tests. Validate by launching Neovim headless and interactively:
  - Headless load check: `nvim --headless +'qa' -u init.lua` (should exit cleanly).
  - Open UI and exercise keymaps, commands, and plugin features.
- Keep changes backward‑compatible where possible; document breaking changes.

## Commit & Pull Request Guidelines
- Commits: short, imperative subject; scope prefixes encouraged (e.g., `plugins:`, `keys:`, `ui:`, `fix:`).
- Group related changes; avoid combining refactors and behavior changes.
- PRs: include a brief description, screenshots or asciicasts for UI changes, and steps to reproduce/test.
- Link related issues and note any follow‑ups (e.g., config migrations).

## Tips & Conventions
- Plugin additions: add a spec file under the appropriate domain in `lua/plugins/<domain>/...` and add a `require("plugins.<domain>.<file>")` entry to `lua/plugins.lua`.
- Secrets: do not commit API keys; read from environment when needed.
- Performance: prefer lazy‑loading where feasible; but keep UI essentials eager; use `:Lazy profile` to inspect startup.

Adding a new plugin (example):
- Create `lua/plugins/editor/myplugin.lua` returning a spec table (or list of specs).
- Reference it from `lua/plugins.lua` with `require("plugins.editor.myplugin")`.
- Put setup in the same file via `config = function() ... end`, or in `lua/plug-config/myplugin.lua` and `require` it from the spec.
- If it has keymaps, add them to `lua/plugins/editor/keymaps.lua` (side‑effect module, no return value).

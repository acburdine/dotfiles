# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for Austin Burdine. Targets macOS (primary) and Ubuntu. Each tool has its own directory containing its config and a `setup.fish` script that symlinks files into place.

## Setup / Installation

Full setup from scratch (clone + configure):
```bash
curl -fsSL https://raw.githubusercontent.com/acburdine/dotfiles/main/install.sh | bash
# or with work profile:
curl -fsSL https://raw.githubusercontent.com/acburdine/dotfiles/main/install.sh | bash -s work
```

Re-run setup after changes (from repo root):
```bash
bash ./setup.sh             # personal (default)
bash ./setup.sh work        # work profile
```

Individual tool setup scripts:
```bash
fish fish/setup.fish
fish git/setup.fish
fish nvim/setup.fish
fish tmux/setup.fish
fish misc-config/setup.fish
```

Install Homebrew packages:
```bash
brew bundle install --file=apps/Brewfile
```

## Architecture

### Directory structure pattern

Each tool directory follows the same pattern:
- `<tool>/setup.fish` — symlinks config files into the appropriate `~/.config/` or `~~/` location
- The actual config files live in the repo and are symlinked (not copied), so edits in `~/` take effect immediately in the repo

### How `setup.sh` works

1. Detects OS and sources `setup-mac.sh` or `setup-ubuntu.sh` for platform-specific config
2. Ensures Homebrew is installed
3. On macOS, runs `setup-apps.sh` which installs `apps/Brewfile` and sets fish as the default shell
4. Calls each tool's `setup.fish` in sequence

The `SETUP_PROFILE` env var (default: `personal`) controls profile-specific behavior (e.g., Firefox as default browser is personal-only; sesh creates both `personal.toml` and `work.toml` in `misc-config/sesh/`).

### Fish shell (`fish/`)

- `config.fish` is symlinked to `~/.config/fish/config.fish`
- `fish_plugins` is symlinked for [fisher](https://github.com/jorgebucaran/fisher) plugin management
- Plugins: `jorgebucaran/nvm.fish`, `ilancosman/tide@v6`
- `functions/` contains custom functions symlinked to `~/.config/fish/functions/`
- Auto-switches Node version via `.nvmrc` on directory change

### Neovim (`nvim/`)

- The entire `nvim/config/` directory is symlinked to `~/.config/nvim`
- Entry point: `nvim/config/init.lua` → `require("acburdine")`
- Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim), configured in `lazy_init.lua`
- Plugin specs live in `nvim/config/lua/acburdine/lazy/` — each file returns a lazy plugin spec
- LSPs managed by mason + mason-lspconfig (see `lazy/lsp.lua` for the `ensure_installed` list)
- Key modules: `set.lua` (vim options), `remap.lua` (keymaps), `commands.lua` (custom commands)

### Tmux (`tmux/`)

- `tmux.conf` symlinked to `~/.tmux.conf`; uses [TPM](https://github.com/tmux-plugins/tpm) for plugins
- `is-vim/` script enables seamless C-h/j/k/l navigation between vim and tmux panes
- Session management via `sesh` with `gum`/`fzf` fuzzy picker (bound to `K` and `J`)

### Misc config (`misc-config/`)

- `setup.fish` symlinks each subdirectory to `~/.config/<dirname>`
- Currently contains: `sesh/` (session manager config), `yamllint/`

### Git (`git/`)

- `gitconfig` symlinked to `~/.gitconfig` (only if one doesn't already exist)
- `gitignore_global` symlinked to `~/.config/git/gitignore_global`
- Commits are GPG-signed (key `FB38863ACF00D553`); uses `diff-so-fancy` as the pager

## CI

GitHub Actions runs `super-linter` on PRs (`.github/workflows/lint.yml`). Lua and Biome format linting are disabled. Codespell is also disabled. The linter validates shell scripts, YAML, and other config formats.

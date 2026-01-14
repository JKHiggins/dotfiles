# Repository Guidelines

## Project Structure & Module Organization
This repository is a personal configuration bundle for CLI tools. Key paths:
- `.zshrc` and `.tmux.conf` for shell/tmux settings.
- `nvim/` for Neovim config (`init.lua`, `lua/jhiggins/` modules, `after/`, `plugin/`, `snippets/`).
- `tmux/` for helper scripts (`sync_dir_fzf.sh`, `change_project.sh`, `copy_mode_with_line_numbers.sh`).
- Tool configs such as `gh/`, `htop/`, `pycodestyle`, and `tmuxinator/`.
- Directories ignored in `.gitignore` (for example `configstore/`, `NuGet/`, `go/`) are machine-local caches; avoid editing or committing them.

## Build, Test, and Development Commands
There is no build system; changes are applied by reloading the relevant tool:
- `tmux source-file ~/.config/.tmux.conf` reloads tmux config.
- Restart `nvim` or run `:source ~/.config/nvim/init.lua` to reload Neovim.
- `sh -n tmux/*.sh` performs a quick syntax check on tmux scripts.

## Coding Style & Naming Conventions
- Lua (Neovim): 2-space indentation; modules live under `nvim/lua/jhiggins/` and are required as `jhiggins.*`.
- Shell scripts: POSIX `sh` with `set -u`; keep indentation at 2 spaces and prefer portable utilities.
- Config files should follow each tool’s native style; avoid reformatting unrelated sections.

## Testing Guidelines
There is no automated test suite. Validate manually:
- Open Neovim and confirm clean startup.
- In tmux, run the script you changed and confirm expected behavior.

## Commit & Pull Request Guidelines
- Commit messages commonly use gitmoji with a scope: `✨ (LSP): Add …`, `🔧 (Tools): Update …`. Keep summaries short and imperative.
- PRs should describe affected tools, list manual validation steps, and include screenshots/gifs for prompt or UI changes.

## Security & Configuration Tips
Keep secrets and tokens out of Git. Prefer local overrides for machine-specific values, and rely on `.gitignore` for local caches.

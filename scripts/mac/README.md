# mac setup

Sets up a new Mac based on the [`README.md`](../../README.md) using homebrew.

## usage

```bash
bash 01-setup-mac.sh
```

Each step asks for confirmation before running, so it is safe to re-run.

## what it does

1. installs Xcode Command Line Tools (if missing) and Homebrew
2. installs all dependencies from `Brewfile` via `brew bundle`
3. sets `nvim` as the global git editor
4. installs `node@lts`, `golang` and `deno` globally via mise
5. clones the dotfiles repo and creates symlinks with stow
6. sets fish as the default shell and installs fisher + catppuccin theme + pure prompt
7. installs tmux plugins (tpm + catppuccin)

## preview without changes

```bash
DRY_RUN=true bash 01-setup-mac.sh
```
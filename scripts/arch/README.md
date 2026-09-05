# arch setup

Sets up an Arch Linux desktop based on the [`README-ARCH.md`](../../README-ARCH.md).

## usage

```bash
bash 01-setup-arch.sh
```

Run as a regular user (sudo is used where needed); the script refuses to run as root.
Each step asks for confirmation before running, so it is safe to re-run.

## what it does

1. installs `base-devel`, `git` and the `paru` AUR helper
2. installs all packages via `pacman` (shell, editors, hyprland group, quickshell, ...)
3. installs AUR packages via `paru` (`waypaper`, `lazydocker`, `localsend-bin`, `brave-bin`, `opencode-bin`)
4. installs `node@lts`, `golang` and `deno` globally via mise
5. clones the dotfiles repo and creates symlinks with stow (incl. the hyprland group)
6. sets `nvim` as the global git editor
7. sets fish as the default shell and installs fisher + catppuccin theme + pure prompt
8. installs tmux plugins (tpm + catppuccin)
9. enables systemd services (`bluetooth`, `iwd`, `fstrim.timer`, `fprintd`)
10. prints manual instructions for Private Internet Access

## preview without changes

```bash
DRY_RUN=true bash 01-setup-arch.sh
```
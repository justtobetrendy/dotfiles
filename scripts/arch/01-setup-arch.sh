#!/usr/bin/env bash
#
# setup-arch.sh — set up an Arch Linux desktop with dotfiles
#
# Based on the README-ARCH at https://github.com/justtobetrendy/dotfiles
# Run it from anywhere and as a regular user (with sudo):
#   bash 01-setup-arch.sh
#
# Each step asks for confirmation, so you can skip anything you already have.

set -Eeuo pipefail

# SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_REPO="https://github.com/justtobetrendy/dotfiles.git"
DOTFILES_DIR="${HOME}/dotfiles"

DRY_RUN="${DRY_RUN:-false}"

PARU_DIR="$(mktemp -d "${TMPDIR:-/tmp}/paru.XXXXXX")"

# Linux + pacman only, and never as root (makepkg/paru refuse root)
[[ "$(uname -s)" == "Linux" ]] || {
    echo "ERROR: this script targets Arch Linux (pacman is required)" >&2
    exit 1
}
command -v pacman &>/dev/null || {
    echo "ERROR: this script targets Arch Linux (pacman is required)" >&2
    exit 1
}
[[ ${EUID} -ne 0 ]] || { echo "ERROR: do not run this script as root" >&2; exit 1; }

# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------

log_info()  { printf "[%s] INFO: %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$*"; }
log_warn()  { printf "[%s] WARN: %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2; }
log_error() { printf "[%s] ERROR: %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2; }

cleanup() {
    [[ -d "${PARU_DIR:-}" ]] && rm -rf -- "$PARU_DIR"
}

on_error() {
    local exit_code="$1"
    local line_no="$2"
    log_error "Failed at line ${line_no} (exit code ${exit_code})"
}

trap cleanup EXIT
trap 'on_error "$?" "$LINENO"' ERR

run_cmd() {
    if [[ "$DRY_RUN" == "true" ]]; then
        printf "[dry-run] %s\n" "$*"
        return 0
    fi
    "$@"
}

confirm() {
    # $1 = prompt; returns 0 (yes) or 1 (no); default yes
    local answer
    while true; do
        printf "%s [Y/n] " "$1"
        if ! IFS= read -r answer < /dev/tty; then
            printf "\n"
            return 1
        fi
        case "$answer" in
            ""|[Yy]|[Yy][Ee][Ss]) return 0 ;;
            [Nn]|[Nn][Oo]) return 1 ;;
            *) log_warn "Please answer y or n." ;;
        esac
    done
}

step_header() {
    printf "\n=====================================================\n"
    printf "  %s\n" "$1"
    printf "=====================================================\n"
}

# ---------------------------------------------------------------------------
# step 1: base-devel, git and the paru AUR helper
# ---------------------------------------------------------------------------

install_paru() {
    step_header "base-devel, git and paru (AUR helper)"
    run_cmd sudo pacman -S --needed --noconfirm base-devel git

    if command -v paru &>/dev/null; then
        log_info "paru already installed at $(command -v paru)"
    elif confirm "Install paru (builds from the AUR, needs your sudo password)?"; then
run_cmd git clone https://aur.archlinux.org/paru.git "$PARU_DIR"
        run_cmd sh -c "cd '$PARU_DIR' && makepkg -si" || {
            log_error "paru build failed. See README-ARCH.md for manual steps."
            return 1
        }
    else
        log_warn "Skipping paru. AUR packages will be skipped too."
        return 0
    fi

    run_cmd paru -Syu
}

# ---------------------------------------------------------------------------
# step 2: install pacman packages
# ---------------------------------------------------------------------------

install_pacman_packages() {
    step_header "Install packages via pacman"

    local -a packages=(
        # core
        stow git tree-sitter-cli fd pacman-contrib mise
        # shell and terminal
        fish ghostty fzf zoxide ripgrep eza
        # editors, multiplexer and tools
        neovim tmux lazygit btop fastfetch yazi
        # apps
        obsidian
        # hyprland group
        hyprland hyprlock hyprpaper hypridle hyprshot hyprsunset
        hyprpolkitagent rofi blueberry impala wiremix brightnessctl
        power-profiles-daemon playerctl dolphin
        # font and wm utilities
        ttf-jetbrains-mono-nerd wl-clipboard
        # misc
        fwupd remmina fprintd
        # quickshell bar
        quickshell unixodbc
    )

    if ! confirm "Install all packages via pacman?"; then
        log_warn "Skipping pacman packages."
        return 0
    fi
    run_cmd sudo pacman -S --needed --noconfirm "${packages[@]}"
}

# ---------------------------------------------------------------------------
# step 3: install AUR packages via paru
# ---------------------------------------------------------------------------

install_aur_packages() {
    step_header "Install AUR packages via paru"
    command -v paru &>/dev/null || { log_warn "paru not installed; skipping"; return 0; }

    local -a packages=(
        waypaper
        lazydocker
        localsend-bin
        brave-bin
        opencode-bin
    )

    if ! confirm "Install AUR packages via paru?"; then
        log_warn "Skipping AUR packages."
        return 0
    fi
    run_cmd paru -S --needed "${packages[@]}"
}

# ---------------------------------------------------------------------------
# step 4: mise runtimes (node, go, deno)
# ---------------------------------------------------------------------------

setup_mise() {
    step_header "mise runtimes (node, golang, deno)"
    command -v mise &>/dev/null || { log_warn "mise not installed; skipping"; return 0; }
    if ! confirm "Install node@lts, golang and deno via mise?"; then
        log_warn "Skipping mise runtimes."
        return 0
    fi
    log_info "Installing node@lts globally..."
    run_cmd mise use --global node@lts
    log_info "Installing golang globally..."
    run_cmd mise use --global go
    log_info "Installing deno globally..."
    run_cmd mise use --global deno
}

# ---------------------------------------------------------------------------
# step 5: clone dotfiles + create symlinks with stow
# ---------------------------------------------------------------------------

clone_dotfiles() {
    step_header "Clone dotfiles + create symlinks"
    if [[ -d "$DOTFILES_DIR/.git" ]]; then
        log_info "dotfiles repo already present at $DOTFILES_DIR"
        return 0
    fi
    if confirm "Clone $DOTFILES_REPO into $DOTFILES_DIR?"; then
        run_cmd git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    else
        log_warn "Skipping clone. Symlinking will be skipped too."
        return 1
    fi
}

stow_dotfiles() {
    command -v stow &>/dev/null || { log_warn "stow not installed; skipping symlinks"; return 0; }
    if ! confirm "Create symlinks with stow (incl. hyprland group)?"; then
        log_warn "Skipping symlinks."
        return 0
    fi

    cd "$DOTFILES_DIR" || { log_error "Cannot cd to $DOTFILES_DIR"; return 1; }

    run_cmd stow fish --no-folding -t "$HOME"
    run_cmd stow btop -t "$HOME"
    run_cmd stow lazygit --no-folding -t "$HOME"
    run_cmd stow ghostty -t "$HOME"
    run_cmd stow nvim -t "$HOME"
    run_cmd stow tmux --no-folding -t "$HOME"
    run_cmd stow yazi -t "$HOME"

    # hyprland group (skips deprecated-swaync/waybar/wlogout/wofi)
    run_cmd stow electron -t "$HOME"
    run_cmd stow hypr -t "$HOME"
    run_cmd stow quickshell -t "$HOME"
    run_cmd stow rofi -t "$HOME"
    run_cmd stow waypaper -t "$HOME"

    log_info "Symlinks created. youtube-music and deprecated dirs skipped."
}

# ---------------------------------------------------------------------------
# step 6: set nvim as the git editor
# ---------------------------------------------------------------------------

setup_git_editor() {
    step_header "git editor"
    command -v git &>/dev/null || { log_warn "git not installed; skipping"; return 0; }
    local current
    current="$(git config --global --get core.editor || true)"
    if [[ -n "$current" ]]; then
        log_info "core.editor already set to: $current"
        return 0
    fi
    if confirm 'Set nvim as the global git editor?'; then
        run_cmd git config --global core.editor "nvim"
    else
        log_warn "Skipping git editor config."
    fi
}

# ---------------------------------------------------------------------------
# step 7: fish shell + fish plugins
# ---------------------------------------------------------------------------

setup_fish() {
    step_header "fish shell plugins"
    command -v fish &>/dev/null || { log_warn "fish not installed; skipping"; return 0; }

    local fish_path
    fish_path="$(command -v fish)"

    if [[ ! -f /etc/shells ]] || ! grep -qx "$fish_path" /etc/shells; then
        log_info "Adding $fish_path to /etc/shells"
        run_cmd sudo bash -c "echo $fish_path >> /etc/shells"
    fi

    if [[ "$SHELL" != "$fish_path" ]]; then
        if confirm "Set fish as your default shell? (chsh needs your password)"; then
            run_cmd sudo chsh -s "$fish_path" "$USER"
        else
            log_warn "Keeping $SHELL as default shell."
        fi
    else
        log_info "fish is already the default shell."
    fi

    if ! confirm "Install fisher + catppuccin theme + pure prompt?"; then
        log_warn "Skipping fish plugins."
        return 0
    fi

    fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
    fish -c 'fisher install catppuccin/fish'
    fish -c 'fish_config theme save "Catppuccin Macchiato"'
    fish -c 'fisher install pure-fish/pure'
}

# ---------------------------------------------------------------------------
# step 8: tmux plugins (tpm + catppuccin)
# ---------------------------------------------------------------------------

setup_tmux() {
    step_header "tmux plugins"
    command -v tmux &>/dev/null || { log_warn "tmux not installed; skipping"; return 0; }
    if ! confirm "Install tmux plugins (tpm + catppuccin)?"; then
        log_warn "Skipping tmux plugins."
        return 0
    fi

    local tpm_dir="${HOME}/.config/tmux/plugins/tpm"
    local catppuccin_dir="${HOME}/.config/tmux/plugins/catppuccin/tmux"

    if [[ -d "$tpm_dir" ]]; then
        log_info "tpm already present: $tpm_dir"
    else
        run_cmd git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi

    if [[ -d "$catppuccin_dir" ]]; then
        log_info "catppuccin/tmux already present: $catppuccin_dir"
    else
        run_cmd git clone -b v2.1.3 https://github.com/catppuccin/tmux.git "$catppuccin_dir"
    fi

    # clones all plugins listed in tmux.conf (tmux-sensible, vim-tmux-navigator, ...)
    run_cmd "$tpm_dir/bin/install_plugins"

    log_info "Start tmux and press the prefix (ctrl-space) then I to complete the plugin setup."
}

# ---------------------------------------------------------------------------
# step 9: systemd services (bluetooth, wifi, fstrim, fprintd)
# ---------------------------------------------------------------------------

setup_systemd_services() {
    step_header "systemd services"
    command -v systemctl &>/dev/null || { log_warn "systemd not available; skipping"; return 0; }
    if ! confirm "Enable systemd services (bluetooth, iwd, fstrim, fprintd)?"; then
        log_warn "Skipping systemd services."
        return 0
    fi

    log_info "Enabling bluetooth.service..."
    run_cmd sudo systemctl enable --now bluetooth.service
    log_info "Enabling iwd.service (impala wifi)..."
    run_cmd sudo systemctl enable iwd.service
    log_info "Enabling fstrim.timer (SSD TRIM)..."
    run_cmd sudo systemctl enable --now fstrim.timer
    log_info "Starting fprintd..."
    run_cmd sudo systemctl start fprintd
}

# ---------------------------------------------------------------------------
# step 10: private internet access (manual)
# ---------------------------------------------------------------------------

pia_instructions() {
    step_header "Private Internet Access (manual)"
    cat <<'EOF'
PIA is installed manually:
  1. download the official client: https://www.privateinternetaccess.com/download
  2. run it once to set it up (enables background process)
  3. optional: add `exec-once = piactl connect` to hyprland.conf
EOF
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

main() {
    log_info "Starting Arch setup. DRY_RUN=$DRY_RUN"

    install_paru
    install_pacman_packages
    install_aur_packages
    setup_mise
    clone_dotfiles && stow_dotfiles
    setup_git_editor
    setup_fish
    setup_tmux
    setup_systemd_services
    pia_instructions

    log_info "Done. Open a new shell to pick up the changes."
}

main "$@"

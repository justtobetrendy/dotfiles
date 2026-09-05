#!/usr/bin/env bash
#
# setup-mac.sh — set up a new Mac with homebrew + dotfiles
#
# Based on the README at https://github.com/justtobetrendy/dotfiles
# Run it from anywhere: bash 01-setup-mac.sh
#
# Each step asks for confirmation, so you can skip anything you already have.

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
BREWFILE="$SCRIPT_DIR/Brewfile"
DOTFILES_REPO="https://github.com/justtobetrendy/dotfiles.git"
DOTFILES_DIR="${HOME}/dotfiles"

DRY_RUN="${DRY_RUN:-false}"

trap 'log_error "Failed at line $LINENO (exit code $?)"' ERR

# macOS only
[[ "$(uname -s)" == "Darwin" ]] || { echo "ERROR: this script targets macOS" >&2; exit 1; }

# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------

log_info()  { printf "[%s] INFO: %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$*"; }
log_warn()  { printf "[%s] WARN: %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2; }
log_error() { printf "[%s] ERROR: %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2; }

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
# step 1: xcode command line tools + homebrew
# ---------------------------------------------------------------------------

ensure_xcode_tools() {
    step_header "Xcode Command Line Tools"
    if xcode-select --print-path &>/dev/null; then
        log_info "Xcode CLT already installed: $(xcode-select --print-path)"
        return 0
    fi
    if confirm "Install Xcode Command Line Tools?"; then
        log_info "Running xcode-select --install (complete the GUI prompt)"
        run_cmd xcode-select --install
        log_warn "Re-run this script after the installer finishes."
        exit 1
    fi
    log_warn "Skipping Xcode CLT. Continue anyway?"
    read -r -N 1 -s -p "[Y/n] " answer < /dev/tty || true
    printf "\n"
    [[ -z "$answer" || "$answer" =~ ^[Yy]$ ]]
}

ensure_homebrew() {
    step_header "Homebrew"
    if command -v brew &>/dev/null; then
        log_info "Homebrew already installed at $(command -v brew)"
        return 0
    fi
    if confirm "Install Homebrew (official installer)?"; then
        log_info "Installing Homebrew..."
        run_cmd /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # shellcheck disable=SC2016
        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        else
            log_error "Homebrew installed but brew not found in PATH. Add it to your shell and re-run."
            return 1
        fi
    else
        log_warn "Skipping Homebrew. Aborting."
        exit 1
    fi
    command -v brew >/dev/null || { log_error "brew still not in PATH"; exit 1; }
    run_cmd brew update
}

# ---------------------------------------------------------------------------
# step 2: install packages via Brewfile
# ---------------------------------------------------------------------------

install_packages() {
    step_header "Install dependencies via Homebrew (Brewfile)"
    [[ -f "$BREWFILE" ]] || { log_error "Brewfile not found: $BREWFILE"; return 1; }
    if ! confirm "Install all packages from $BREWFILE?"; then
        log_warn "Skipping package installation."
        return 0
    fi
    run_cmd brew bundle --file="$BREWFILE"
}

# ---------------------------------------------------------------------------
# step 3: set nvim as the git editor
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
# step 5: clone repo + create symlinks with stow
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
    if ! confirm "Create symlinks with stow?"; then
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

    log_info "Symlinks created. Hyprland/deprecated dirs skipped (Linux only)."
}

# ---------------------------------------------------------------------------
# step 6: fish shell + fish plugins
# ---------------------------------------------------------------------------

setup_fish() {
    step_header "fish shell plugins"
    command -v fish &>/dev/null || { log_warn "fish not installed; skipping"; return 0; }

    if [[ "$SHELL" != "$(command -v fish)" ]]; then
        if confirm "Set fish as your default shell? (sudo chsh needs your password)"; then
            if command -v fish | grep -q /usr/local; then
                # keep fish a valid login shell on intel homebrew
                run_cmd sudo bash -c 'echo /usr/local/bin/fish >> /etc/shells'
            fi
            run_cmd sudo chsh -s "$(command -v fish)" "$USER"
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
# step 7: tmux plugins (tpm + catppuccin)
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
# main
# ---------------------------------------------------------------------------

main() {
    log_info "Starting macOS setup. DRY_RUN=$DRY_RUN"

    if [[ "$DRY_RUN" == "false" ]] && [[ ${EUID} -eq 0 ]]; then
        log_error "Do not run this script as root."
        exit 1
    fi

    ensure_xcode_tools
    ensure_homebrew

    if [[ "$DRY_RUN" == "false" ]]; then
        # shellcheck disable=SC2016
        eval "$(brew shellenv)"
    fi

    install_packages
    setup_git_editor
    setup_mise
    clone_dotfiles && stow_dotfiles
    setup_fish
    setup_tmux

    log_info "Done. Open a new shell to pick up the changes."
}

main "$@"

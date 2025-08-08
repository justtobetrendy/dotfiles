To apply configuration, copy paste directory in `~/.config/`.

## Install

### prerequisits

Node (via [n](https://github.com/tj/n), see node [download page](https://nodejs.org/en/download) and select `n`) and GoLang (or LSP will not install)

- [nerdfont](https://www.nerdfonts.com/) JetBrainsMono Nerd Font Mono [via homebrew](https://formulae.brew.sh/cask/font-jetbrains-mono-nerd-font)

### terminal

- [wezterm](https://wezfurlong.org/wezterm/index.html) via homebrew (cask) -- deprecated
- [ghostty](https://ghostty.org/) via homebrew (cask)
- [ohmyposh](https://ohmyposh.dev/) via homebrew -- deprecated
- [fish](https://fishshell.com/) via homebrew
- [fisher](https://github.com/jorgebucaran/fisher)
    - [catppuccin color scheme for fish](https://github.com/catppuccin/fish) via fisher
    - [pure prompt for fish](https://github.com/pure-fish/pure) via fisher

```
~> fisher install catppuccin/fish
~> fish_config theme save "Catppuccin Macchiato"
~> fisher install pure-fish/pure
```

### terminal cli

- [bat](https://github.com/sharkdp/bat) via homebrew -- deprecated
- [git](https://git-scm.com/downloads) via homebrew
- [fzf](https://github.com/junegunn/fzf) via homebrew
- [zoxide](https://github.com/ajeetdsouza/zoxide) via homebrew
- [ripgrep](https://github.com/BurntSushi/ripgrep) via homebrew
- [lazygit](https://github.com/jesseduffield/lazygit) via homebrew
- [lazydocker](https://github.com/jesseduffield/lazydocker) via homebrew
- [timeshift](https://github.com/linuxmint/timeshift) via pacman

### tmux

- [tmux](https://github.com/tmux/tmux/wiki) via homebrew
- [tpm](https://github.com/tmux-plugins/tpm) - catppuccin tmux theme needs to be installed manually

### neovim

- [neovim](https://neovim.io/) via homebrew
- set nvim as default git editor `git config --global core.editor "nvim"`

after initial load run `:Copilot setup`

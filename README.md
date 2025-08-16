To apply configuration, copy paste directory in `~/.config/`.

## Install

to add a simlink `stow nvim -t ~`
to remove a simlink `stow -D nvim -t ~`

special for fish: `stow fish --no-folding -t ~`
special for tmux: `stow tmux --no-folding -t ~`


### Arch Linux

[Paru (AUR)](https://github.com/Morganamilo/paru)

```
sudo pacman -S neovim fish ghostty git tmux mise ttf-jetbrains-mono-nerd lazygit fastfetch obsidian zoxide fzf wl-clipboard eza stow snapper
```

```
paru -S lazydocker btrfs-assistant
```

chsh -s /usr/bin/fish

install brave // TODO: from AUR ?

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

[tmux](https://github.com/tmux/tmux/wiki)
[tpm](https://github.com/tmux-plugins/tpm) after installing tpm, the catppuccin theme needs to be [installed manualy](https://github.com/catppuccin/tmux?tab=readme-ov-file#installation)

### neovim

- [neovim](https://neovim.io/) via homebrew
- set nvim as default git editor `git config --global core.editor "nvim"`

after initial load run `:Copilot setup`

### Hyprland

```
sudo pacman -S waybar hyprlock hyprpaper hypridle hyprshot hyprsunset hyprpolkitagent blueberry impala wiremix brightnessctl swaync
paru -S wlogout waypaper
```

systemctl enable iwd.service (for impala)
systemctl start fprintd
systemctl enable bluetooth.service 
systemctl start bluetooth.service 

for swaync to work we need to remove `org.knopwob.dunst.service` (or the file containing `dunst` in it's filename) from `/usr/share/dbus-1/services`
 
### GTK Themes

- Install nwg-look `sudo pacman -S nwg-look`
- Find themes: https://www.gnome-look.org/u/fkorpsvart, https://www.gnome-look.org/u/vinceliuice, https://www.gnome-look.org/u/eliverlara
- Extract theme zip files and place them under `~/.themes`
- use nwg-look to select theme

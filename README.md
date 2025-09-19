## dotfiles

### install stow

Dotfiles may be installed using [gnu stow](https://www.gnu.org/software/stow/).

Arch
```bash
sudo pacman -S stow
```

Mac
```bash
brew install stow
```

### clone the repo

```
git clone https://github.com/justtobetrendy/dotfiles.git 
```

### create simlinks 


| app | command | description |
| - | - | - |
| fish | `stow fish --no-folding -t ~` | shell |
| ghostty | `stow ghostty -t ~` | terminal | 
| nvim | `stow nvim -t ~` | text editor |
| tmux | `stow tmux --no-folding -t ~` | terminal multiplexer |
| youtube-music | `stow youtube-music -t ~` | activate wayland for youtube-music-bin electron app |


#### hyprland


| app | command | description |
| - | - | - |
| electron | `stow electron -t ~` | activate wayland for electron apps such as obsidian |
| hypr | `stow hypr -t ~` | hyprland window compositor |
| rofi | `stow rofi -t ~` | launcher and menu |
| swaync | `stow swaync -t ~` | notifications |
| waybar | `stow waybar -t ~` | hyprland bar |
| waypaper | `stow waypaper -t ~` | wallpaper switcher |
| wlogout | `stow wlogout -t ~` | deprecated in favor of rofi menu - logout menu |

### to remove simlinks

`stow -D diretory -t ~`

## arch linux

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

### terminal cli

- [bat](https://github.com/sharkdp/bat) via homebrew -- deprecated
- [git](https://git-scm.com/downloads) via homebrew
- [fzf](https://github.com/junegunn/fzf) via homebrew
- [zoxide](https://github.com/ajeetdsouza/zoxide) via homebrew
- [ripgrep](https://github.com/BurntSushi/ripgrep) via homebrew
- [lazygit](https://github.com/jesseduffield/lazygit) via homebrew
- [lazydocker](https://github.com/jesseduffield/lazydocker) via homebrew
 
### GTK Themes

- Install nwg-look `sudo pacman -S nwg-look gtk-engine-murrine gnome-themes-extra sassc`
- Find themes: https://www.gnome-look.org/u/fkorpsvart, https://www.gnome-look.org/u/vinceliuice, https://www.gnome-look.org/u/eliverlara
- Extract theme zip files and place them under `~/.themes`
- use nwg-look to select theme

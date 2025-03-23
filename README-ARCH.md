# arch linux

## 1. activate AUR

Install git

```bash
sudo pacman -S git
```

Install [Paru](https://github.com/Morganamilo/paru) AUR helper (validate procedure before executing commands)

```bash
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

## 2. install tools

Install [mise-en-place](https://mise.jdx.dev/)

```bash
sudo pacman -S mise 
```

Install tools globaly

```bash
mise use --global node@lts
mise use --global go
mise use --global deno
```

## 3. shell and terminal

Install [Ghostty](https://ghostty.org/) and [Fish](https://fishshell.com/)

```bash
sudo pacman -S ghostty fish 
```

Set Fish as default shell 

```bash
chsh -s /usr/bin/fish
```

### Fish plugins

Install [Fisher](https://github.com/jorgebucaran/fisher) followed by the [Pure prompt](https://github.com/pure-fish/pure) and [Catppuccin theme](https://github.com/catppuccin/fish) (validate procedures before executing commands)

```bash
# fisher 
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# catppuccin theme
fisher install catppuccin/fish
fish_config theme save "Catppuccin Macchiato"

# pure prompt
fisher install pure-fish/pure
```

## 4. neovim and tmux

Install [neovim](https://neovim.io/) and [tmux](https://github.com/tmux/tmux/wiki)

```bash
sudo pacman -S neovim tmux
```

Set neovim as the git editor (e.g.: for interactive rebase)

```bash
git config --global core.editor "nvim"
```

Install [tpm](https://github.com/tmux-plugins/tpm) (validate procedure before executing commands)

```bash
mkd -p ~/.config/tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
``` 

Install the catppuccin theme [manually](https://github.com/catppuccin/tmux?tab=readme-ov-file#installation) (validate procedure before executing commands)

```bash
mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
```

## 5. private internet access 

- Download the [official client](https://www.privateinternetaccess.com/download) and run it once to set it up
- Enable background process `piactl background enable`
- Add the following to hyprland.conf `exec-once = piactl connect`

## 6. hyprland

```bash
sudo pacman -S waybar hyprlock hyprpaper hypridle hyprshot hyprsunset hyprpolkitagent blueberry impala wiremix brightnessctl swaync power-profiles-daemon rofi
paru -S waypaper
```

- `systemctl enable iwd.service` (for impala)
- `systemctl start fprintd`
- `systemctl enable bluetooth.service`
- `systemctl start bluetooth.service`
- `sudo systemctl enable --now fstrim.timer` activate TRIM for SSD

for swaync to work we may need to remove `org.knopwob.dunst.service` (or the file containing `dunst` in it's filename) from `/usr/share/dbus-1/services`

## other apps

```bash
sudo pacman -S ttf-jetbrains-mono-nerd lazygit fastfetch obsidian zoxide fzf wl-clipboard eza stow fwupd remmina fprintd btop
```

```bash
paru -S lazydocker youtube-music-bin localsend-bin opencode-bin
```

## misc

- use `sudo -E timeshift-gtk` to run timeshift in hyprland 


# +++++++++++++++++++++++++
# zinit plugin manager 

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download zinit if it's not already there
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

# +++++++++++++++++++++++++
# zinit plugins 

# zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode # seems to conflict with fzf ctrl-r
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# +++++++++++++++++++++++++
# oh my posh 

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/catppuccin-macchiato.toml)"
fi

# +++++++++++++++++++++++++
# nvm 

# nvm is very slow, trying n https://github.com/tj/n 
#
# export NVM_DIR="$HOME/.nvm"
# zinit ice wait"0" atload"!nvm use default >/dev/null 2>&1 || true" pick"nvm.sh" silent
# zinit light https://github.com/nvm-sh/nvm

# +++++++++++++++++++++++++
# zoxide

eval "$(zoxide init zsh)"

# +++++++++++++++++++++++++
# fzf 

source <(fzf --zsh)

# +++++++++++++++++++++++++
# configurations 

# key bindings
bindkey '^y' autosuggest-accept #zsh-autosuggestions

# aliases
alias ls='ls --color'
alias nvimi='nvim $(fzf -m --preview="bat --color=always {}")'

# completion styling
autoload -Uz compinit && compinit
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case insensitive completion match
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' # case insensitive completion only when no match
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # colors to completions

# history related settings
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space # does not save command to history if it starts with space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# +++++++++++++++++++++++++
# themes 

# catppuccin-macchiato for fzf
export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=selected-bg:#494d64 \
--color=border:#363a4f,label:#cad3f5"

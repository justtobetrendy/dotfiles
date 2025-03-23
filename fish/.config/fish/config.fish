if status is-interactive
    # Commands to run in interactive sessions can go here
end

bind ctrl-y accept-autosuggestion 

zoxide init fish | source
fzf --fish | source
mise activate fish | source

alias cd "z"
alias ls "eza -al"
alias lt 'eza -aT --color=always --group-directories-first --icons'

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Custom path exports
export GOPATH=$(go env GOPATH)
export PATH=/usr/local/bin:/usr/local/sbin:$PATH:/Users/aburdine/bin:$GOPATH/bin:/opt/cisco/anyconnect/bin

export EDITOR="nvim"

# Prompt Customization
GIT_PS1_SHOWDIRTYSTATE=true
export PS1="\[\033[38;5;8m\]-[\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput sgr0)\]\[\033[38;5;8m\]]-[\[$(tput sgr0)\]\[\033[38;5;2m\]\u\[$(tput sgr0)\]\[\033[38;5;8m\]]\[$(tput sgr0)\]\[\033[38;5;15m\]\$(__git_ps1 \"\e[90m-[\e[33m%s\e[90m]\")\[$(tput sgr0)\]\n\\$\[$(tput sgr0)\] "
# export PS1="\[\033[36m\]\u \[\033[33;1m\]\w \[\033[1;34m\]\$(__git_ps1 \"\e[90m-[\e[33m%s\e[90m]\")\[\033[m\] \$ "
# source ~/.prompt.sh
export PS2="> "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Aliases
alias ls='ls -GFh'
alias bp='nvim ~/.bash_profile'
alias bpr=". ~/.bash_profile"
alias g="git"
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline"
alias hs="hub sync"
alias loadenv='f() { source ~/.env/"$1".env; }; f'
complete -o default -o nospace -F _git g

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

alias ax='aws-okta exec --mfa-factor-type push'
alias tf='f() { if [ $# -lt 2 ]; then echo "please run \"tf <profile> <cmd>\""; else ax "$1" -- terraform "${@:2}"; fi }; f'
alias tfinit='terraform init'
alias gentfdocs='~/go/bin/terraform-docs md . > README.md'
alias ch='f() { if [ $# -lt 2 ]; then echo "please run \"ch <profile> <cmd>\""; else ax "$1" -- chamber "${@:2}"; fi }; f'

# editor alias
alias vi="nvim"
alias vim="nvim"

# tmux
alias tmn="tmux new -s"
alias tma="tmux a -t"

function prompt {
  read -p "${1}: " val
  echo $val
}

[ -f ~/.dem-tokens ] && source ~/.dem-tokens
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/bin/z/z.sh ] && source ~/bin/z/z.sh

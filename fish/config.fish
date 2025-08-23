# if we're in cloudsdk, don't do anything because it messes stuff up
if set -q CLOUDSDK_WRAPPER && test "$CLOUDSDK_WRAPPER" = 1
    return
end

# custom path exports
if type -q go
    set -x GOPATH (go env GOPATH)
end

# note: fix homebrew path
/opt/homebrew/bin/brew shellenv | source

fish_add_path -gaP (path filter \
  $HOME/bin \
  $HOME/.cargo/bin \
  $HOME/.local/bin \
  $HOME/.rd/bin
)

set -x EDITOR nvim

set -x RUST_SRC_PATH $HOME/.rustup/toolchains/nightly-x86_64-apple-darwin/lib/rustlib/src/rust/library

set -x GPG_TTY (tty)

# ensure SHELL is set correctly for things like tmux
# (environments like Codespaces don't normally set it correctly)
set -x SHELL (status fish-path)

# disable fish greeting
set fish_greeting

alias ls="ls -GFh"
alias fp="nvim ~/.config/fish/config.fish"
alias fpr="source ~/.config/fish/config.fish"
alias g="git"
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline"
alias gln="git log --oneline -n"
alias gg="git grep"
alias hs="hub sync"
alias chromeguest="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --guest"
alias tml="tmux ls"
alias tm='sesh connect "$(sesh list -i | gum filter --limit 1 --placeholder \'Pick a sesh\' --prompt='⚡')"'

alias avx="aws-vault exec"
alias tfinit="terraform init"
alias tfv="terraform validate"
alias k="kubectl"

# because I was tired of googling this each time
alias portsinuse="sudo lsof -i -P | grep LISTEN"

# editor aliases
alias vi="nvim"
alias vim="nvim"

alias lg="lazygit"

alias gentfdocs="terraform-docs markdown table . > README.md"

alias hotspot="sudo networksetup -setmanual Wi-Fi 172.20.10.3 255.255.255.240 172.20.10.1"
alias unhotspot="sudo networksetup -setdhcp Wi-Fi"

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

alias gcl="gcloud auth print-access-token >/dev/null"
alias gcal="gcloud auth application-default login"

if test -e ~/.config/fish/aliases.fish
    source ~/.config/fish/aliases.fish
end

if test -e ~/.config/fish/tokens.fish
    source ~/.config/fish/tokens.fish
end

if test -e ~/.asdf/asdf.fish
    source ~/.asdf/asdf.fish
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/bin/gcloud/path.fish.inc" ]
    source "$HOME/bin/gcloud/path.fish.inc"
end

if test -n $CODESPACES && ! type -q fisher && status --is-login
    echo "fisher not found, installing it"
    fish -c "curl -sL https://git.io/fisher | source && fisher update" 2>/dev/null
end

set --universal nvm_default_version v22
set --universal nvm_default_packages pm2@latest nx@latest turbo@latest

function __check_nvm --on-variable PWD --description 'automatic nvm use'
    if test -f .nvmrc
        set node_version ''
        if type -q node
            set node_version (node -v)
        end

        set nvmrc_node_version (nvm list | grep (cat .nvmrc))

        if test -z "$nvmrc_node_version"
            nvm install
        else if string match -q -- "*$node_version" $nvmrc_node_version
            # already current node version
        else
            nvm use
        end
    end
end

__check_nvm

tide configure --auto --style=Rainbow --prompt_colors='True color' \
    --show_time='24-hour format' \
    --rainbow_prompt_separators=Slanted \
    --powerline_prompt_heads=Sharp \
    --powerline_prompt_tails=Flat \
    --powerline_prompt_style='Two lines, character' \
    --prompt_connection=Dotted \
    --powerline_right_prompt_frame=No \
    --prompt_connection_andor_frame_color=Lightest \
    --prompt_spacing=Sparse \
    --icons='Few icons' \
    --transient=Yes

# setup zoxide
zoxide init fish | source
# setup fzf
fzf --fish | source

# always clear at the end
clear

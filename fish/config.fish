# if we're in cloudsdk, don't do anything because it messes stuff up
if set -q CLOUDSDK_WRAPPER && test "$CLOUDSDK_WRAPPER" = 1
    return
end

# custom path exports
if type -q go
    set -x GOPATH (go env GOPATH)
end

# NOTE: it looks like homebrew is here multiple times, this is just easier than trying
# to do os-specific logic
set -x PATH /usr/local/bin /opt/homebrew/bin /opt/homebrew/opt/ruby/bin /home/linuxbrew/.linuxbrew/bin \
    /usr/local/sbin $PATH $HOME/bin $GOPATH/bin $HOME/.cargo/bin \
    /opt/cisco/anyconnect/bin $HOME/.composer/vendor/bin \
    /usr/local/opt/php/bin /usr/local/opt/php/sbin

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

function __check_nvm --on-variable PWD --description 'automatic nvm use'
    if test -f .nvmrc
        set node_version (node -v)
        set nvmrc_node_version (nvm list | grep (cat .nvmrc))

        if set -q $nvmrc_node_version
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

# always clear at the end
clear

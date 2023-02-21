# custom path exports
if type -q go
  set -x GOPATH (go env GOPATH)
end

# NOTE: it looks like homebrew is here multiple times, this is just easier than trying
# to do os-specific logic
set -x PATH /usr/local/bin /opt/homebrew/bin /home/linuxbrew/.linuxbrew/bin \
            /usr/local/sbin $PATH $HOME/bin $GOPATH/bin $HOME/.cargo/bin \
            /opt/cisco/anyconnect/bin $HOME/.composer/vendor/bin \
            /usr/local/opt/php/bin /usr/local/opt/php/sbin

set -x EDITOR nvim

set -x RUST_SRC_PATH $HOME/.rustup/toolchains/nightly-x86_64-apple-darwin/lib/rustlib/src/rust/library

set -x GPG_TTY (tty)

# ensure SHELL is set correctly for things like tmux
# (environments like Codespaces don't normally set it correctly)
set -x SHELL (status fish-path)

# disable homebrew google analytics
set -x HOMEBREW_NO_GOOGLE_ANALYTICS 1

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

# because I was tired of googling this each time
alias portsinuse="sudo lsof -i -P | grep LISTEN"

# editor aliases
alias vi="nvim"
alias vim="nvim"

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
if [ -f "$HOME/bin/gcloud/path.fish.inc" ]; source "$HOME/bin/gcloud/path.fish.inc"; end

if test -n $CODESPACES && ! type -q fisher && status --is-login
  echo "fisher not found, installing it"
  fish -c "curl -sL https://git.io/fisher | source && fisher update" 2>/dev/null
end

# always clear at the end
clear

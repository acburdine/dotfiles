set DIR (dirname (status --current-filename))

ln -sf "$DIR/tmux.conf" $HOME/.tmux.conf
tmux -f $HOME/.tmux.conf new -d -s tmp '~/.tmux/plugins/tpm/bin/install_plugins; tmux wait-for -S setup'
tmux wait-for setup

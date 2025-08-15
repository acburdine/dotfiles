set DIR (dirname (status --current-filename))

# link is-vim shell script
mkdir -p ~/.config/tmux/
ln -sf "$DIR/is-vim" $HOME/.config/tmux/is-vim

ln -sf "$DIR/tmux.conf" $HOME/.tmux.conf
tmux -f $HOME/.tmux.conf new -d -s tmp '~/.tmux/plugins/tpm/bin/install_plugins; tmux wait-for -S setup'
tmux wait-for setup

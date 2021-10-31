set DIR (dirname (status --current-filename))

mkdir -p $HOME/.config/git/
ln -sf "$DIR/gitignore_global" $HOME/.config/git/gitignore_global

# don't overwrite gitconfig if already set
if ! test -e $HOME/.gitconfig
  ln -sf "$DIR/gitconfig" $HOME/.gitconfig
end

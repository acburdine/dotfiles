set DIR (dirname (status --current-filename))

mkdir -p $HOME/.config/git/
ln -sf "$DIR/gitignore_global" $HOME/.config/git/gitignore_global
ln -sf "$DIR/gitconfig" $HOME/.gitconfig

if ! type -q diff-so-fancy
  echo "installing diff-so-fancy"

  # install diff-so-fancy
  if type -q apt-get
    sudo apt-get update
    sudo apt-get install -y diff-so-fancy
  else if type -q brew
    brew install diff-so-fancy
  end
end

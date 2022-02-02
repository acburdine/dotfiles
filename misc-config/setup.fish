set DIR (dirname (status --current-filename))

mkdir -p $HOME/.config/
for f in $DIR/*/
  set base (basename $f)
  echo "linking $base config..."
  ln -sf $f $HOME/.config/$base
end

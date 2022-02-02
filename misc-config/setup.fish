set DIR (dirname (status --current-filename))

for fd in $DIR/*/
  set base (basename $fd)
  echo "linking $base config..."

  mkdir -p $HOME/.config/$base

  for f in $fd/*
    ln -sf $f $HOME/.config/$base/(basename $f)
  end
end

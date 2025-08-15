set DIR (dirname (status --current-filename))

for fd in $DIR/*/
    set base (basename $fd)
    echo "linking $base config..."
    ln -sf $fd $HOME/.config/$base
end

# create sesh configs
touch $DIR/sesh/personal.toml
touch $DIR/sesh/work.toml

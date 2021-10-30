set DIR (dirname (status --current-filename))

mkdir -p $HOME/.config/fish/conf.d
mkdir -p $HOME/.config/fish/functions

ln -sf $DIR/config.fish $HOME/.config/fish/config.fish
ln -sf $DIR/fish_plugins $HOME/.config/fish/fish_plugins
ln -sf $DIR/conf.d/*.fish $HOME/.config/fish/conf.d/
ln -sf $DIR/functions/*.fish $HOME/.config/fish/functions/

touch $HOME/.dem-tokens && chmod 600 $HOME/.dem-tokens

if ! type -q fisher
  echo "installing fisher plugin"
  curl -sL https://git.io/fisher | source
end

fisher update

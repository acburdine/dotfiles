set DIR (dirname (status --current-filename))

mkdir -p $HOME/.config/nvim/
ln -sf "$DIR/init.vim" $HOME/.config/nvim/init.vim
ln -sf "$DIR/ftplugin" $HOME/.config/nvim/ftplugin
ln -sf "$DIR/lua" $HOME/.config/nvim/lua

if ! type -q node
  nvm install lts
end

nvim -es -u $HOME/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "UpdateRemotePlugins" -c "qa"

mkdir -p $HOME/.config/coc/extensions
ln -sf "$DIR/coc-package.json" $HOME/.config/coc/extensions/package.json
cd $HOME/.config/coc/extensions && \
  npm install --quiet --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod && \
  cd -

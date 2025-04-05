#!/usr/bin/env bash
STOW_FOLDERS="config,firefox,git,wallpaper"

if [[ -z $DOTFILES ]]; then
    DOTFILES=$HOME/.dotfiles
fi

pushd "$DOTFILES"
for folder in $(echo $STOW_FOLDERS | tr ',' ' ')
do
    echo "Restowing $folder..."
    stow --target="$HOME" --restow "$folder"
done
popd

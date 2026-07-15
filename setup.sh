#!/usr/bin/env bash

set -euo pipefail

main() {
    local wallpaper_dir="$HOME/Pictures/Wallpapers2"
    local dotfiles_repo="https://github.com/caiocsx/dotfiles.git"

    echo "Creating wallpaper directory..."
    mkdir -p "$wallpaper_dir"

    local tmp
    tmp="$(mktemp -d)"
    trap "rm -rf '$tmp'" EXIT

    echo "Cloning dotfiles repository..."
    git clone --depth=1 "$dotfiles_repo" "$tmp"

    echo "Copying wallpapers to $wallpaper_dir..."
    cp -r "$tmp/assets/." "$wallpaper_dir/"

    echo "Wallpapers installed successfully!"
}

main "$@"

#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo ":: Creating ~/.config directory if needed..."
mkdir -p "$CONFIG_DIR"

echo ":: Linking configurations..."
for config in "$DOTFILES_DIR/.config"/*; do
    target_name="$(basename "$config")"
    target_dest="$CONFIG_DIR/$target_name"

    # Backup existing config if it is an actual directory and not a symlink
    if [ -e "$target_dest" ] && [ ! -L "$target_dest" ]; then
        echo "   Backing up existing $target_name to $target_dest.bak"
        mv "$target_dest" "${target_dest}.bak"
    fi

    echo "   Linking $target_name -> $target_dest"
    ln -sfn "$config" "$target_dest"
done

echo ":: Reloading Hyprland..."
hyprctl reload 2>/dev/null || true

echo ":: Dotfiles successfully installed!"

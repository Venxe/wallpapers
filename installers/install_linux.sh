#!/bin/bash

INSTALL_DIR="/tmp/wallpapers"
WALLS_DIR="/home/sayimburak/wallpapers/walls"

handle_error() {
    echo -e "\033[31mError: $1\033[0m"
    exit 1
}

git clone --depth 1 https://github.com/sayimburak/wallpapers.git "$INSTALL_DIR" || handle_error "Clone failed."

find "$INSTALL_DIR/wallpapers" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) ! -iname "README.md" -exec bash -c '
  file="$1"
  category=$(dirname "$file" | sed "s|$2/||")
  dest_dir="$3/$category"

  mkdir -p "$dest_dir" || exit 1
  if [ -e "$dest_dir/$(basename "$file")" ]; then
    echo -e "\033[33mFile $(basename "$file") already exists. Skipping...\033[0m"
  else
    mv "$file" "$dest_dir" || exit 1
  fi
' bash {} "$INSTALL_DIR/wallpapers" "$WALLS_DIR" \;

echo -e "\033[32mWallpaper installation complete.\033[0m"

rm -rf "$INSTALL_DIR" || handle_error "Failed to remove $INSTALL_DIR"
rm -- "$0" || handle_error "Failed to remove the script."

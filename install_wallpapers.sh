#!/bin/bash

INSTALL_DIR="/tmp/wallpapers"
WALLS_DIR="/home/sayimburak/wallpapers/walls"

echo "Downloading wallpapers repository..."
git clone --depth 1 https://github.com/Venxe/wallpapers.git "$INSTALL_DIR"

echo "Processing and moving wallpapers..."

find "$INSTALL_DIR/wallpapers" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) ! -iname "README.md" -exec bash -c '
  file="$1"
  category=$(dirname "$file" | sed "s|$2/||")
  dest_dir="$3/$category"
  
  mkdir -p "$dest_dir"
  mv "$file" "$dest_dir"
' bash {} "$INSTALL_DIR/wallpapers" "$WALLS_DIR" \;

echo "Cleaning up temporary files..."
rm -rf "$INSTALL_DIR"

echo "Wallpaper installation complete."


# Set variables
$INSTALL_DIR = "$env:TEMP\wallpapers"
$WALLS_DIR = "C:\Users\$env:USERNAME\Pictures\Wallpapers\Walls"

# Download wallpapers repository
Write-Host "Downloading wallpapers repository..."
git clone --depth 1 https://github.com/Venxe/wallpapers.git "$INSTALL_DIR"

# Processing and moving wallpapers
Write-Host "Processing and moving wallpapers..."
$files = Get-ChildItem -Path "$INSTALL_DIR\wallpapers" -Recurse -Include *.jpg, *.jpeg, *.png, *.webp

foreach ($file in $files) {
    $category = $file.DirectoryName.Replace("$INSTALL_DIR\wallpapers\", "")
    $dest_dir = Join-Path -Path $WALLS_DIR -ChildPath $category

    # Create category directory if it doesn't exist
    if (-not (Test-Path -Path $dest_dir)) {
        New-Item -ItemType Directory -Force -Path $dest_dir
    }

    # Move the file
    Move-Item -Path $file.FullName -Destination $dest_dir
}

# Clean up temporary files
Write-Host "Cleaning up temporary files..."
Remove-Item -Recurse -Force $INSTALL_DIR

Write-Host "Wallpaper installation complete."

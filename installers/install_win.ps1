$installDir = "$env:TEMP\wallpapers"
$wallpapersDir = "C:\Users\$env:USERNAME\Pictures\Wallpapers"

# Check if the directory exists, if not, create it
if (-not (Test-Path $wallpapersDir)) {
    New-Item -ItemType Directory -Force -Path $wallpapersDir
}

# Cloning the repository
git clone --depth 1 https://github.com/Venxe/wallpapers.git $installDir

# Moving the wallpapers
Get-ChildItem -Path "$installDir\wallpapers" -Recurse -Include *.jpg, *.jpeg, *.png, *.webp | ForEach-Object {
    $file = $_
    $category = $file.DirectoryName.Replace("$installDir\wallpapers\", "")
    $destDir = "$wallpapersDir\$category"

    # Check if the category directory exists, if not, create it
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Force -Path $destDir
    }

    # Move the wallpaper file
    Move-Item -Path $file.FullName -Destination $destDir
}

# Clean up
Remove-Item -Recurse -Force $installDir

Write-Host "Wallpaper installation complete."

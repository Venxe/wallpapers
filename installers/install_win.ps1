$installDir = "$env:TEMP\wallpapers"
$wallpapersDir = "C:\Users\$env:USERNAME\Pictures\Wallpapers"

# Ensure wallpapers directory exists
if (-not (Test-Path $wallpapersDir)) {
    New-Item -ItemType Directory -Force -Path $wallpapersDir
}

# Clone the repository
git clone --depth 1 https://github.com/Venxe/wallpapers.git $installDir

# Move wallpapers to categorized directories
Get-ChildItem -Path "$installDir\wallpapers" -Recurse -Include *.jpg, *.jpeg, *.png, *.webp | ForEach-Object {
    $category = $_.DirectoryName.Replace("$installDir\wallpapers\", "")
    $destDir = "$wallpapersDir\$category"

    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Force -Path $destDir
    }

    $destFile = "$destDir\$($_.Name)"

    if (Test-Path $destFile) {
        Write-Warning "File '$($_.Name)' already exists in the destination directory. Skipping."
    } else {
        Move-Item -Path $_.FullName -Destination $destDir
    }
}

# Clean up temporary files
Remove-Item -Recurse -Force $installDir

# Delete the script itself
Remove-Item -Path $MyInvocation.MyCommand.Path -Force

Write-Host "Wallpaper installation complete."

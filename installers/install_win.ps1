$installDir = "$env:TEMP\wallpapers"
$wallpapersDir = ""

if ($env:LANG -match "tr") {
    $wallpapersDir = "$env:USERPROFILE\Resimler\Wallpapers"
} else {
    $wallpapersDir = "$env:USERPROFILE\Pictures\Wallpapers"
}

if (-not (Test-Path $wallpapersDir)) {
    New-Item -ItemType Directory -Force -Path $wallpapersDir
}

git clone --depth 1 https://github.com/Venxe/wallpapers.git $installDir

<<<<<<< HEAD
$wallpapers = Get-ChildItem -Path "$installDir\wallpapers" -Recurse -Include *.jpg, *.jpeg, *.png, *.webp

if ($wallpapers.Count -eq 0) {
    Write-Host "No wallpapers found to move." -ForegroundColor Red
} else {
    Write-Host "Found $($wallpapers.Count) wallpapers. Organizing them..." -ForegroundColor Cyan
}

$wallpapers | ForEach-Object {
=======
Get-ChildItem -Path "$installDir\wallpapers" -Recurse -Include *.jpg, *.jpeg, *.png, *.webp | ForEach-Object {
>>>>>>> parent of 31acfc2 (Update install_win.ps1)
    $category = $_.DirectoryName.Replace("$installDir\wallpapers\", "")
    $destDir = "$wallpapersDir\$category"

    if (-not (Test-Path $destDir)) {
<<<<<<< HEAD
        Write-Host "Category folder '$category' does not exist. Creating it..." -ForegroundColor Green
=======
>>>>>>> parent of 31acfc2 (Update install_win.ps1)
        New-Item -ItemType Directory -Force -Path $destDir
    }

    $destFile = "$destDir\$($_.Name)"

    if (Test-Path $destFile) {
        Write-Warning "File '$($_.Name)' already exists in the destination directory. Skipping."
    } else {
        Move-Item -Path $_.FullName -Destination $destDir
    }
}

<<<<<<< HEAD
Write-Host "Wallpaper installation complete!" -ForegroundColor Green

=======
Write-Host "Wallpaper installation complete."
>>>>>>> parent of 31acfc2 (Update install_win.ps1)
Remove-Item -Recurse -Force $installDir
Remove-Item -Path $MyInvocation.MyCommand.Path -Force

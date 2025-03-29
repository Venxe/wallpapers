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

Get-ChildItem -Path "$installDir\wallpapers" -Recurse -Include *.jpg, *.jpeg, *.png, *.webp | ForEach-Object {
    $category = $_.DirectoryName.Replace("$installDir\wallpapers\", "")
    $destDir = "$wallpapersDir\$category"

    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Force -Path $destDir
    }

    $destFile = "$destDir\$($_.Name)"

    if (Test-Path $destFile) {
        Write-Warning -ForegroundColor Yellow "File '$($_.Name)' already exists in the destination directory. Skipping."
    } else {
        Move-Item -Path $_.FullName -Destination $destDir
    }
}

Write-Host -ForegroundColor Green "Wallpaper installation complete."
Remove-Item -Recurse -Force $installDir
Remove-Item -Path $MyInvocation.MyCommand.Path -Force

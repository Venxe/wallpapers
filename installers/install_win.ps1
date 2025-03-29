$installDir = "$env:TEMP\wallpapers"
$wallpapersDir = ""

if ($env:LANG -match "tr") {
    $wallpapersDir = "$env:USERPROFILE\Resimler\Wallpapers"
} else {
    $wallpapersDir = "$env:USERPROFILE\Pictures\Wallpapers"
}

if (-not (Test-Path $wallpapersDir)) {
    Write-Host "Creating wallpapers directory at: $wallpapersDir" -ForegroundColor Green
    New-Item -ItemType Directory -Force -Path $wallpapersDir
} else {
    Write-Host "Wallpapers directory already exists: $wallpapersDir" -ForegroundColor Yellow
}

Write-Host "Cloning wallpapers from GitHub..." -ForegroundColor Cyan
git clone --depth 1 https://github.com/Venxe/wallpapers.git $installDir

$wallpapers = Get-ChildItem -Path "$installDir\wallpapers" -Recurse -Include *.jpg, *.jpeg, *.png, *.webp

if ($wallpapers.Count -eq 0) {
    Write-Host "No wallpapers found to move." -ForegroundColor Red
} else {
    Write-Host "Found $($wallpapers.Count) wallpapers. Organizing them..." -ForegroundColor Cyan
}

$wallpapers | ForEach-Object {
    $category = $_.DirectoryName.Replace("$installDir\wallpapers\", "")
    $destDir = "$wallpapersDir\$category"

    if (-not (Test-Path $destDir)) {
        Write-Host "Category folder '$category' does not exist. Creating it..." -ForegroundColor Green
        New-Item -ItemType Directory -Force -Path $destDir
    }

    $destFile = "$destDir\$($_.Name)"

    if (Test-Path $destFile) {
        Write-Warning "File '$($_.Name)' already exists in the destination directory. Skipping." 
    } else {
        Move-Item -Path $_.FullName -Destination $destDir
    }
}

Write-Host "Wallpaper installation complete!" -ForegroundColor Green

Remove-Item -Recurse -Force $installDir
Remove-Item -Path $MyInvocation.MyCommand.Path -Force

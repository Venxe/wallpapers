# Install-Wallpapers.ps1

$installDir = "C:\temp\wallpapers"
$wallsDir = "C:\Users\sayimburak\wallpapers\walls"
$zipFile = "$installDir\wallpapers.zip"

if (-not (Test-Path -Path $installDir)) {
    New-Item -ItemType Directory -Force -Path $installDir
}

Write-Host "Downloading wallpapers repository..."
try {
    Invoke-WebRequest -Uri "https://github.com/Venxe/wallpapers/archive/refs/heads/main.zip" -OutFile $zipFile -TimeoutSec 600
} catch {
    Write-Host "An error occurred during download: $_"
    exit 1
}

Write-Host "Extracting wallpapers..."
try {
    Expand-Archive -Path $zipFile -DestinationPath $installDir -Force
} catch {
    Write-Host "Error during extraction: $_"
    exit 1
}

Write-Host "Processing and moving wallpapers..."
Get-ChildItem -Recurse -File -Path "$installDir\wallpapers-main" | Where-Object { $_.Extension -match "jpg|jpeg|png|webp" } | ForEach-Object {
    $category = $_.DirectoryName -replace "$installDir\wallpapers-main", ""
    $destDir = Join-Path -Path $wallsDir -ChildPath $category
    New-Item -ItemType Directory -Force -Path $destDir
    Move-Item -Path $_.FullName -Destination $destDir
}

Write-Host "Cleaning up temporary files..."
Remove-Item -Recurse -Force "$installDir"

Write-Host "Wallpaper installation complete."

# Install-Wallpapers.ps1

$installDir = "C:\temp\wallpapers"
$wallsDir = "C:\Users\sayimburak\wallpapers\walls"

# Hedef dizini oluştur
if (-not (Test-Path -Path $installDir)) {
    New-Item -ItemType Directory -Force -Path $installDir
}

Write-Host "Downloading wallpapers repository..."
Invoke-WebRequest -Uri "https://github.com/Venxe/wallpapers/archive/refs/heads/main.zip" -OutFile "$installDir\wallpapers.zip"

Write-Host "Extracting wallpapers..."
Expand-Archive -Path "$installDir\wallpapers.zip" -DestinationPath "$installDir"

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

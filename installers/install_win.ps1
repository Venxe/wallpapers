$installDir = "$env:TEMP\wallpapers"
$wallpapersDir = [System.Environment]::GetFolderPath('MyPictures')
$wallpapersDir = "$wallpapersDir\Wallpapers"

if (-not (Test-Path $wallpapersDir)) {
    New-Item -ItemType Directory -Force -Path $wallpapersDir
}

try {
    Write-Host "Cloning repository..." -ForegroundColor Cyan
    git clone --depth 1 https://github.com/sayimburak/wallpapers.git $installDir

    Get-ChildItem -Path "$installDir\wallpapers" -Recurse -Include *.jpg, *.jpeg, *.png, *.webp | ForEach-Object {
        $category = $_.DirectoryName.Replace("$installDir\wallpapers\", "")
        $destDir = "$wallpapersDir\$category"

        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Force -Path $destDir
        }

        $destFile = "$destDir\$($_.Name)"
        if (Test-Path $destFile) {
            Write-Host -ForegroundColor Yellow "File '$($_.Name)' already exists in the destination directory. Skipping."
        } else {
            Move-Item -Path $_.FullName -Destination $destDir
        }
    }

    Write-Host -ForegroundColor Green "Wallpaper installation complete."
}
catch {
    Write-Host -ForegroundColor Red "An error occurred during the wallpaper installation: $_"
}
finally {
    Remove-Item -Recurse -Force $installDir
    Remove-Item -Path $MyInvocation.MyCommand.Path -Force
}

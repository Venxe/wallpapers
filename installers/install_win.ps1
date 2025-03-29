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

# Hata yakalama ve işlem kontrolü için try-catch bloğu
try {
    # Git ile indirme işlemini başlat
    Write-Host "Cloning repository..." -ForegroundColor Cyan
    $gitCloneResult = git clone --depth 1 https://github.com/Venxe/wallpapers.git $installDir 2>&1

    # Git'in çıktısını kontrol et
    if ($gitCloneResult -match "fatal:") {
        Write-Host -ForegroundColor Red "Git clone failed: $gitCloneResult"
        throw "Git clone failed"
    }

    # Get-ChildItem çıktısını gizle
    $null = Get-ChildItem -Path "$installDir\wallpapers" -Recurse -Include *.jpg, *.jpeg, *.png, *.webp | ForEach-Object {
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
}
catch {
    # Hata durumu
    Write-Host -ForegroundColor Red "An error occurred: $_"
}
finally {
    # Temporary install directory'i sil
    Remove-Item -Recurse -Force $installDir
    Remove-Item -Path $MyInvocation.MyCommand.Path -Force
}

function Download-Wallpapers {
    $installDir = "$env:TEMP\wallpapers"
    $wallpapersDir = [System.Environment]::GetFolderPath('MyPictures') + "\Wallpapers"

    if (-not (Test-Path $wallpapersDir)) {
        New-Item -ItemType Directory -Force -Path $wallpapersDir
    }

    try {
        Write-Host "Cloning repository..." -ForegroundColor Cyan
        git clone --depth 1 https://github.com/Venxe/wallpapers.git $installDir

        Get-ChildItem -Path "$installDir\wallpapers" -Recurse -Include *.jpg, *.jpeg, *.png, *.webp | ForEach-Object {
            $category = $_.DirectoryName.Replace("$installDir\wallpapers\", "")
            $destDir = "$wallpapersDir\$category"

            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Force -Path $destDir
            }

            $destFile = "$destDir\$($_.Name)"
            if (-not (Test-Path $destFile)) {
                Move-Item -Path $_.FullName -Destination $destDir
            } else {
                Write-Host -ForegroundColor Yellow "File '$($_.Name)' already exists. Skipping."
            }
        }

        Write-Host -ForegroundColor Green "Wallpaper installation complete."
    }
    catch {
        Write-Host -ForegroundColor Red "An error occurred: $_"
    }
    finally {
        Remove-Item -Recurse -Force $installDir -ErrorAction SilentlyContinue
    }
}

function Enable-WebPBackground {
    $regFile = "$env:TEMP\webp-bg.reg"
    $regContent = @"
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\SystemFileAssociations\.webp\Shell]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.webp\Shell\setdesktopwallpaper]
@="Set as Desktop Wallpaper"
"MultiSelectModel"="Player"
"NeverDefault"=""

[HKEY_CLASSES_ROOT\SystemFileAssociations\.webp\Shell\setdesktopwallpaper\Command]
@="rundll32.exe %SystemRoot%\\System32\\shimgvw.dll,ImageView_SetWallpaper %1"
"DelegateExecute"="{ff609cc7-d34d-4049-a1aa-2293517ffcc6}"
"@

    $regContent | Set-Content -Path $regFile -Encoding ASCII
    Start-Process "regedit.exe" -ArgumentList "/s `"$regFile`"" -Wait -NoNewWindow
}

Download-Wallpapers
Enable-WebPBackground

Remove-Item -Path $MyInvocation.MyCommand.Path -Force -ErrorAction SilentlyContinue

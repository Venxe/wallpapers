@echo off

set INSTALL_DIR=%TEMP%\wallpapers
set WALLS_DIR=C:\Users\%USERNAME%\Pictures\Wallpapers\Walls

echo Downloading wallpapers repository...
git clone --depth 1 https://github.com/Venxe/wallpapers.git "%INSTALL_DIR%"

echo Processing and moving wallpapers...

for /r "%INSTALL_DIR%\wallpapers" %%F in (*.jpg *.jpeg *.png *.webp) do (
    set "file=%%F"
    setlocal enabledelayedexpansion
    for %%a in (!file!) do (
        set "category=%%~dpa"
        set "category=!category:%INSTALL_DIR%\wallpapers\=!"
        set "dest_dir=%WALLS_DIR%\!category!"

        if not exist "!dest_dir!" mkdir "!dest_dir!"
        move "%%F" "!dest_dir!\"
    )
    endlocal
)

echo Cleaning up temporary files...
rd /s /q "%INSTALL_DIR%"

echo Wallpaper installation complete.

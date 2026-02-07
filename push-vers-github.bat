@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo.
echo ========================================
echo   Push URC Interface vers GitHub
echo   Ayman-cell/front-end
echo ========================================
echo.

if not exist ".git" (
    echo Initialisation du depot Git...
    git init
    git branch -M main
    git remote add origin https://github.com/Ayman-cell/front-end.git
)

echo Ajout de tous les fichiers...
git add -A

echo.
echo Creation du commit...
git commit -m "URC Championship interface - README et application complete"

echo.
echo Push vers https://github.com/Ayman-cell/front-end ...
git push -u origin main

echo.
echo Termine.
pause

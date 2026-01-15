@echo off
echo ========================================
echo    PREPARATION DE LA VERSION PUBLIC
echo ========================================

:: 1. Compiler le projet
echo Compilation en cours...
dotnet publish --configuration Release --runtime win-x64 --self-contained true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true --output ./publish
if %errorlevel% neq 0 (
    echo Erreur lors de la compilation.
    pause
    exit /b
)

:: 2. Nettoyer les fichiers inutiles
if exist ".\publish\createdump.exe" del ".\publish\createdump.exe"
if exist ".\publish\ShardOfEternisLauncher.pdb" del ".\publish\ShardOfEternisLauncher.pdb"

:: 3. Créer le ZIP
echo.
echo Creation de l'archive ZIP...
powershell -Command "Compress-Archive -Path '.\publish\ShardOfEternisLauncher.exe' -DestinationPath '.\publish\ShardOfEternisLauncher.zip' -Force"

echo.
echo ========================================
echo    ARCHIVE PRETE !
echo ========================================
echo.
echo Le fichier a partager est : ShardOfEternisLauncher.zip
echo Il se trouve dans le dossier 'publish' qui va s'ouvrir.
echo.

:: 4. Ouvrir le dossier
explorer .\publish
pause
@echo off
REM Se placer dans le dossier du script pour que dotnet trouve le csproj
setlocal
cd /d "%~dp0"
echo ========================================
echo    Shard of Eternis Launcher - Compilation
echo ========================================
echo.
echo Dépôt GitHub: https://github.com/Witherproduction/shard-of-eternis
echo.

REM Vérifier si .NET SDK est installé
dotnet --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR: .NET SDK n'est pas installé.
    echo.
    echo Téléchargez et installez .NET 6.0 SDK ou plus récent depuis:
    echo https://dotnet.microsoft.com/download
    echo.
    pause
    exit /b 1
)

echo .NET SDK détecté:
dotnet --version
echo.

echo Restauration des packages...
dotnet restore
if %errorlevel% neq 0 (
    echo ERREUR: Échec de la restauration des packages
    pause
    exit /b 1
)

echo.
echo Compilation en mode Release...
dotnet build --configuration Release
if %errorlevel% neq 0 (
    echo ERREUR: Échec de la compilation
    pause
    exit /b 1
)
echo.
echo Publication d'un exécutable autonome (Fichier unique)...
dotnet publish --configuration Release --runtime win-x64 --self-contained true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true --output ./publish
if %errorlevel% neq 0 (
    echo ERREUR: Échec de la publication
    pause
    exit /b 1
)

REM Nettoyage des fichiers inutiles
if exist ".\publish\createdump.exe" del ".\publish\createdump.exe"

echo.
echo ========================================
echo    COMPILATION TERMINÉE AVEC SUCCÈS!
echo ========================================
echo.
echo L'exécutable se trouve dans: .\publish\ShardOfEternisLauncher.exe
echo.
pause
param(
    [string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$TempRoot = (Join-Path $env:LOCALAPPDATA "GameMakerStudio2\\GMS2TEMP"),
    [string]$UserDataRoot = (Join-Path $env:LOCALAPPDATA "shard_of_eternis"),
    [ValidateSet("AUTO","GMS2TEMP","APPDATA")]
    [string]$Source = "AUTO",
    [string]$VmFolder = "",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $TempRoot)) {
    throw "TempRoot introuvable: $TempRoot"
}

$candidates = Get-ChildItem -Path $TempRoot -Directory -Filter "shard_of_eternis_*_VM" -ErrorAction SilentlyContinue
if (-not $candidates -or $candidates.Count -eq 0) {
    throw "Aucun dossier GMS2TEMP trouvé pour 'shard_of_eternis_*_VM' dans: $TempRoot"
}

if (-not [string]::IsNullOrWhiteSpace($VmFolder)) {
    $candidates = $candidates | Where-Object { $_.Name -eq $VmFolder }
    if (-not $candidates -or $candidates.Count -eq 0) {
        throw "VmFolder introuvable: $VmFolder (dans $TempRoot)"
    }
}

$best = $null
$bestScenarioRoot = $null
$bestStamp = [DateTime]::MinValue

foreach ($cand in $candidates) {
    $scenarioRoot = Join-Path $cand.FullName "scenarios"
    if (-not (Test-Path $scenarioRoot)) { continue }

    $latestJson = Get-ChildItem -Path $scenarioRoot -Recurse -File -Filter "*.json" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($null -eq $latestJson) { continue }

    if ($latestJson.LastWriteTime -gt $bestStamp) {
        $best = $cand
        $bestScenarioRoot = $scenarioRoot
        $bestStamp = $latestJson.LastWriteTime
    }
}

if ($null -eq $best) {
    throw "Aucun dossier GMS2TEMP avec des JSON trouvés (scenarios\\**\\*.json) dans: $TempRoot"
}

$srcRoot = $bestScenarioRoot
$chosenSourceLabel = "GMS2TEMP"
$chosenStamp = $bestStamp

$userScenarioRoot = Join-Path $UserDataRoot "scenarios"
$userLatestJson = $null
if (Test-Path $userScenarioRoot) {
    $userLatestJson = Get-ChildItem -Path $userScenarioRoot -Recurse -File -Filter "*.json" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
}

if ($Source -eq "APPDATA") {
    if (-not (Test-Path $userScenarioRoot)) {
        throw "Source=APPDATA mais dossier introuvable: $userScenarioRoot"
    }
    $srcRoot = $userScenarioRoot
    $chosenSourceLabel = "APPDATA"
    $chosenStamp = if ($null -ne $userLatestJson) { $userLatestJson.LastWriteTime } else { [DateTime]::MinValue }
} elseif ($Source -eq "GMS2TEMP") {
    $srcRoot = $bestScenarioRoot
    $chosenSourceLabel = "GMS2TEMP"
    $chosenStamp = $bestStamp
} else {
    if ($null -ne $userLatestJson -and $userLatestJson.LastWriteTime -gt $chosenStamp) {
        $srcRoot = $userScenarioRoot
        $chosenSourceLabel = "APPDATA"
        $chosenStamp = $userLatestJson.LastWriteTime
    }
}
if (-not (Test-Path $srcRoot)) {
    throw "Dossier 'scenarios' introuvable dans la source choisie: $srcRoot"
}

$dstRoot = Join-Path $ProjectRoot "datafiles\\scenarios"
if (-not (Test-Path $dstRoot)) {
    New-Item -Path $dstRoot -ItemType Directory | Out-Null
}

$files = Get-ChildItem -Path $srcRoot -Recurse -File -Filter "*.json" -ErrorAction SilentlyContinue
if (-not $files -or $files.Count -eq 0) {
    throw "Aucun fichier JSON trouvé dans: $srcRoot"
}

Write-Host "Source: $srcRoot"
Write-Host "Cible : $dstRoot"
Write-Host "Source choisie: $chosenSourceLabel"
if ($chosenSourceLabel -eq "GMS2TEMP") { Write-Host "Dossier temp utilisé: $($best.FullName)" }
Write-Host "Dernière modif détectée: $chosenStamp"
Write-Host ""

$copied = 0
foreach ($f in $files) {
    $rel = $f.FullName.Substring($srcRoot.Length).TrimStart("\","/")
    $target = Join-Path $dstRoot $rel
    $targetDir = Split-Path -Parent $target
    if (-not (Test-Path $targetDir)) {
        if (-not $DryRun) { New-Item -Path $targetDir -ItemType Directory | Out-Null }
    }

    if ($DryRun) {
        Write-Host "[DRY] $rel -> $target"
    } else {
        Copy-Item -Path $f.FullName -Destination $target -Force
        Write-Host "OK   $rel -> $target"
    }
    $copied += 1
}

Write-Host ""
Write-Host "Fichiers traités: $copied"

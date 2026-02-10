$jsonPath = "f:\shard of eternis dev\shard-of-eternis\datafiles\cards_database.json"

try {
    $jsonContent = Get-Content -Path $jsonPath -Raw -Encoding UTF8
    $data = $jsonContent | ConvertFrom-Json
} catch {
    try {
        $jsonContent = Get-Content -Path $jsonPath -Raw -Encoding Default
        $data = $jsonContent | ConvertFrom-Json
    } catch {
        exit
    }
}

$cards = $data.cards_database
$cardIds = $cards | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name

$found = $false
foreach ($id in $cardIds) {
    $card = $cards.$id
    if ($card.PSObject.Properties['effects']) {
        Write-Host "Found effects in card: $($card.name)"
        $found = $true
        break
    }
}

if (-not $found) {
    Write-Host "No card has 'effects' property."
}

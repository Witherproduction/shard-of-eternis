$jsonPath = "f:\shard of eternis dev\shard-of-eternis\datafiles\cards_database.json"

Write-Host "Reading file..."
try {
    $jsonContent = Get-Content -Path $jsonPath -Raw -Encoding UTF8
    $data = $jsonContent | ConvertFrom-Json
} catch {
    Write-Host "Error with UTF8, trying Default encoding..."
    try {
        $jsonContent = Get-Content -Path $jsonPath -Raw -Encoding Default
        $data = $jsonContent | ConvertFrom-Json
    } catch {
        Write-Host "Error reading or parsing JSON: $_"
        exit
    }
}

$cards = $data.cards_database
$cardIds = $cards | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name

$count = 0
foreach ($id in $cardIds) {
    $card = $cards.$id
    if ($card.PSObject.Properties['effects']) {
        Write-Host "Card: $($card.name)"
        $card.effects | ConvertTo-Json -Depth 3
        $count++
        if ($count -ge 5) { break }
    }
}

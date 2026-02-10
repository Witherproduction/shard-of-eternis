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
$firstCard = $cards.($cardIds[0])
Write-Host "Properties of first card ($($firstCard.name)):"
$firstCard | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name

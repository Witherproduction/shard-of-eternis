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

if (-not $data.cards_database) {
    Write-Host "No cards_database found in JSON root."
    # Print first few properties of data
    $data | Get-Member
    exit
}

$cards = $data.cards_database
$cardIds = $cards | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
Write-Host "Found $($cardIds.Count) cards in database."

$damageCards = @()

foreach ($id in $cardIds) {
    $card = $cards.$id
    $hasDamage = $false
    $element = "neutre"

    if ($card.PSObject.Properties['element']) {
        $element = $card.element
    }

    if ($card.PSObject.Properties['effects']) {
        # Write-Host "Checking effects for $($card.name)..."
        foreach ($effect in $card.effects) {
            $effType = ""
            if ($effect.PSObject.Properties['effect_type']) { $effType = $effect.effect_type.ToLower() }
            
            $op = ""
            if ($effect.PSObject.Properties['op']) { $op = $effect.op.ToLower() }
            
            # Write-Host "  - Effect: $effType, Op: $op"
            
            if ($effType -like "*damage*" -or $op -eq "damage") {
                $hasDamage = $true
                if ($effect.PSObject.Properties['element']) {
                    $element = $effect.element
                }
                break
            }
        }
    } else {
        # Write-Host "No effects for $($card.name)"
    }

    if ($hasDamage) {
        $damageCards += [PSCustomObject]@{
            Name = $card.name
            Element = $element
        }
    }
}

Write-Host "Found $($damageCards.Count) damage cards."
$damageCards | Sort-Object Element, Name | Format-Table -AutoSize

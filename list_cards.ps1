$path = "datafiles\cards_database.json"
$json = Get-Content $path -Raw -Encoding UTF8 | ConvertFrom-Json
$cards = $json.cards_database
$list = @()
foreach ($prop in $cards.PSObject.Properties) {
    $c = $prop.Value
    if ($null -ne $c.mana_cost) {
        $obj = [PSCustomObject]@{
            Name = $c.name
            ID = $c.id
            Cost = [int][Math]::Round($c.mana_cost)
            Type = $c.type
            Attack = $c.attack
            PV = $c.PV
            Desc = $c.description
            Race = $c.race
        }
        $list += $obj
    }
}
$list | Sort-Object Cost, Name | ConvertTo-Json -Depth 2 | Out-File "cards_list.json" -Encoding UTF8
$files = Get-ChildItem -Path . -Recurse -Include *.gml,*.json

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    # Replace 'star' with 'mana_cost' (whole word)
    $content = $content -replace '\bstar\b', 'mana_cost'
    
    # Replace 'defense' with 'PV' (whole word)
    $content = $content -replace '\bdefense\b', 'PV'
    
    # Replace 'def' with 'PV' (whole word)
    $content = $content -replace '\bdef\b', 'PV'
    
    if ($content -ne $originalContent) {
        Set-Content $file.FullName -Value $content -Encoding UTF8
        Write-Host "Updated: $($file.Name)"
    }
}

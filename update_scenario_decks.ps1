
$path = "c:\Users\arckano\Desktop\jeu\shard-of-eternis\datafiles\scenarios\ch1\scenario_chapter_1_act_2.json"
$json = Get-Content -Path $path -Raw -Encoding UTF8 | ConvertFrom-Json

# Loop through scenes and update duel_player_deck
foreach ($scene in $json.scenes) {
    if ($scene.duel_bot_id -eq 2) {
        if ($null -eq $scene.duel_player_deck) {
            $scene | Add-Member -MemberType NoteProperty -Name "duel_player_deck" -Value "foret_abyssienne" -Force
        } else {
            $scene.duel_player_deck = "foret_abyssienne"
        }
        Write-Host "Updated Scene (Bot 2) with player deck: foret_abyssienne"
    }
    elseif ($scene.duel_bot_id -eq 3) {
        if ($null -eq $scene.duel_player_deck) {
            $scene | Add-Member -MemberType NoteProperty -Name "duel_player_deck" -Value "voleur_hist" -Force
        } else {
            $scene.duel_player_deck = "voleur_hist"
        }
        Write-Host "Updated Scene (Bot 3) with player deck: voleur_hist"
    }
}

$json | ConvertTo-Json -Depth 10 | Set-Content -Path $path -Encoding UTF8
Write-Host "Done updating scenario."

event_inherited();
race = "Nature";

name = "Griffe du prÃ©dateur";
genre = "Sort";
rarity = "commune";
booster = "Retour des Archontes";
is_player_card = true;

description = "Donne +2/+1 Ã  une BÃªte alliÃ©e.";
mana_cost = 1; // CoÃ»t estimÃ© (Ã©tait ArtÃ©fact)

effects = [
    {
        id: 1,
        trigger: TRIGGER_MAIN_PHASE,
        effect_type: EFFECT_BUFF,
        scope: "single",
        target_zone: "field",
        ally_only: true, // Important pour le ciblage
        criteria: { type: "Monster", genre: "BÃªte" },
        atk: 2,
        PV: 1
    }
];
tags = ["Sort", "Nature"];

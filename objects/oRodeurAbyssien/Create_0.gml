event_inherited();  // HÃ©rite des variables et comportement de oCardMonster

// DÃ©finit les stats spÃ©cifiques de ce monstre
name = "RÃ´deur Abyssien"
attack = 3;
PV = 3;
mana_cost = 3;
genre = "HumanoÃ¯de"
booster = "Retour des Archontes"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // DÃ©finit explicitement cette carte comme appartenant au joueur
description = "Camouflage. Aube : Ajoute un 'Abyssien' de votre cimetiÃ¨re ou deck Ã  votre main."
effects = [
    {
        id: 1,
        trigger: TRIGGER_ENTER_FIELD,
        effect_type: EFFECT_CAMOUFLAGE
    },
    {
        id: 2,
        trigger: TRIGGER_START_TURN,
        effect_type: EFFECT_SEARCH,
        search_sources: ["Graveyard", "Deck"],
        destination: "Hand",
        max_targets: 1,
        random_select: false,
        search_criteria: { name_contains: "Abyssien" },
        label: "Aube"
	}
		]
race = "Abyssien";
tags = ["HumanoÃ¯de", "Abyssien", "Camouflage", "Aube"];

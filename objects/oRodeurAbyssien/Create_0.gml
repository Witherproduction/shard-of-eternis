event_inherited();  // Hérite des variables et comportement de oCardMonster

// Définit les stats spécifiques de ce monstre
name = "Rôdeur Abyssien"
attack = 5;
defense = 4;
star = 2;
genre = "Humanoïde"
archetype = "Forêt des voleurs"
booster = "A la découverte du monde"
rarity = "rare"
lastTurnAttack = 0;
is_player_card = true; // Définit explicitement cette carte comme appartenant au joueur
description = "Camouflage. Aube : Ajoute un 'Abyssien' de votre cimetière ou deck à votre main."
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
show_debug_message("### oGraveyard.create")
// Liste des cartes envoyées au cimetière (dernière carte = fin du tableau)
cards = [];
isHeroOwner = false; // false par défaut, sera true pour le cimetière héros dans la room


/// Fonction : ajouter une carte au cimetière
/// @param {instance} card - carte à envoyer au cimetière
/// @param {bool} suppress_triggers - si true, n'active aucun trigger (par défaut false)
addToGraveyard = function(card, suppress_triggers = false) {
    show_debug_message("### oGraveyard.addToGraveyard: " + string(card));

    // Vérifier que l'instance existe avant de l'ajouter
    if(instance_exists(card)) {
        // Déterminer le nom canonique depuis l'instance (préférence name)
        if (variable_instance_exists(card, "name")) cname = card.name; else cname = object_get_name(card.object_index);
        
        // Créer une copie des propriétés de la carte
        var cardData = {
            sprite_index: object_get_sprite(card.object_index),
            image_index: 0, // Toujours face visible dans le cimetière
            name: cname,
            cardType: card.type,
            race: (variable_instance_exists(card, "race") ? card.race : ""),
            archetype: (variable_instance_exists(card, "archetype") ? card.archetype : ""),
            genre: (variable_instance_exists(card, "genre") ? card.genre : ""),
            attack: card.attack,
            PV: card.PV,
            mana_cost: card.mana_cost,
            description: card.description,
            isHeroOwner: card.isHeroOwner,
            isFaceDown: false,
            object_index: card.object_index // Ajout pour correspondance robuste
        };
        
        // Ajoute les données de la carte à la liste du cimetière
        array_push(cards, cardData);
        show_debug_message("### oGraveyard: count=" + string(array_length(cards)) + " owner=" + string(isHeroOwner));

        // Marque de décomposition: si la carte marquée meurt ce tour, piocher 1 carte
        if (instance_exists(game)
            && variable_instance_exists(card, "mark_draw_on_death_turn")
            && variable_instance_exists(card, "mark_draw_on_death_owner_is_hero")) {
            var markedTurn = card.mark_draw_on_death_turn;
            var drawOwnerIsHero = card.mark_draw_on_death_owner_is_hero;
            if (markedTurn == game.nbTurn) {
                var deckInst = drawOwnerIsHero ? deckHero : deckEnemy;
                if (instance_exists(deckInst) && variable_instance_exists(deckInst, "pick")) {
                    deckInst.pick();
                }
            }
            card.mark_draw_on_death_turn = undefined;
            card.mark_draw_on_death_owner_is_hero = undefined;
        }

        // Déclenchements associés au cimetière sauf si suppression demandée
        if (!suppress_triggers) {
            var sac_for = (variable_global_exists("sacrifice_for_card") && instance_exists(global.sacrifice_for_card)) ? global.sacrifice_for_card : noone;
            var ctxBase = { to_graveyard: self, owner_is_hero: isHeroOwner, from_sacrifice: (variable_global_exists("sacrifice_in_progress") ? global.sacrifice_in_progress : false), from_discard: (variable_global_exists("discard_in_progress") ? global.discard_in_progress : false), sacrifice_for: sac_for };
            registerTriggerEvent(TRIGGER_ENTER_GRAVEYARD, card, ctxBase);
            var ctxMonster = { target: card, to_graveyard: self, owner_is_hero: isHeroOwner, suppress_fx_aura: true, from_sacrifice: ctxBase.from_sacrifice, from_discard: ctxBase.from_discard, sacrifice_for: sac_for };
            registerTriggerEvent(TRIGGER_ON_MONSTER_SENT_TO_GRAVEYARD, card, ctxMonster);
        }
    }
};


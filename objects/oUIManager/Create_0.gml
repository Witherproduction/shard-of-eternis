show_debug_message("### oUIManager.create")

// Initialiser le flag global d'overlay d'action
global.isActionMenuOpen = false;

///////////////////////////////////////////////////////////////////////
// Attributs
///////////////////////////////////////////////////////////////////////

//selected = "";
selectedSummonOrSet = "";
instanceSummon = "";
// instanceSet removed
// instancePositionButton removed
instanceAttackButton = "";
instanceEffectButton = "";


///////////////////////////////////////////////////////////////////////
// Méthodes
///////////////////////////////////////////////////////////////////////

//----------------------------------
// Summon et Set
//----------------------------------

#region Function displaySummonSetAction
displaySummonSetAction = function(card) {show_debug_message("### oUIManager.displaySummonSetAction")

    // Nettoyer tout ancien bouton avant de créer de nouveaux
    if (instanceSummon != "" && instance_exists(instanceSummon)) { instance_destroy(instanceSummon); instanceSummon = ""; }
    if (instanceEffectButton != "" && instance_exists(instanceEffectButton)) { instance_destroy(instanceEffectButton); instanceEffectButton = ""; }

    // Montrer Summon/Set uniquement pour les monstres et si l'invocation normale est possible
    var canNormalSummon = false;
    if (card != noone && instance_exists(card)) {
        if (card.type == "Monster") {
            // Vérifier s'il y a de la place sur le terrain (sauf si sacrifice nécessaire)
            var hasFreeSlot = false;
            var reqSacrifice = getSacrificeLevel(card.mana_cost);
            
            // Si monstre de niveau 1, il faut un slot libre
            if (card.mana_cost == 1) {
                var fm = instance_exists(fieldManagerHero) ? fieldManagerHero : instance_find(oFieldManagerHero, 0);
                if (fm != noone && instance_exists(fm)) {
                    var monsterField = fm.getField("Monster");
                    if (monsterField != noone && variable_struct_exists(monsterField, "cards")) {
                        for (var i = 0; i < array_length(monsterField.cards); i++) {
                            if (monsterField.cards[i] == 0) { hasFreeSlot = true; break; }
                        }
                    }
                }
            } else {
                // Pour les autres niveaux (2, 3, etc.), on affiche les boutons (soit sacrifice, soit autre logique)
                hasFreeSlot = true;
            }

            // HS: Phase Main au lieu de Summon. Pas de limite d'invocation par tour (juste Mana)
            canNormalSummon = (game.phase[game.phase_current] == "Main"
                               && game.is_local_turn
                               // && !game.hasSummonedThisTurn[game.local_player_index] // Pas de limite en HS
                               && hasFreeSlot);
        }
    }

    if (canNormalSummon) {
        // Position centrée pour le bouton unique (Play/Summon)
        instanceSummon = instance_create_layer(card.x, card.y - 280, layer_get_id("Instances"), oSummon);
        instanceSummon.parentCard = card;
        instanceSummon.depth = -2000;
        // instanceSet supprimé (pas de Set en HS)
        instanceSummon.image_xscale = 0.5;
        instanceSummon.image_yscale = 0.5;
    }

    // Actions pour les cartes Magie en main (Play)
    if (card != noone && instance_exists(card) && card.type == "Magic") {
        // Centraliser l'affichage du bouton effet selon les règles courantes
        // Cela créera le bouton d'effet (Swirl) qui gère le "Play" pour les magies (ciblage ou direct)
        UIManager.displayEffectButton(card);
    }

    // Bouton effet pour cartes non-Magie en main si disponible
    if (card != noone && instance_exists(card) && card.type != "Magic") {
        var effectOther = getAvailableEffect(card);
        if (effectOther != noone) {
            instanceEffectButton = instance_create_layer(card.x + 80, card.y - 280, layer_get_id("Instances"), oEffectButton);
            instanceEffectButton.parentCard = card;
            instanceEffectButton.depth = -2000;
            instanceEffectButton.image_xscale = 0.4;
            instanceEffectButton.image_yscale = 0.4;
        }
    }
    
    // Activer le blocage des clics sur le terrain tant que des boutons sont visibles
    if (instanceSummon != "" || instanceEffectButton != "") {
        global.isActionMenuOpen = true;
    }
}
#endregion


#region Function hideSummonAndSet
hideSummonAndSet = function() {show_debug_message("### oUIManager.hideSummonAndSet")

    // Cache le bouton Summon
    if(instanceSummon != "") {
        instance_destroy(instanceSummon);
        instanceSummon = "";
    }
    // Cache le bouton d'effet
    if(instanceEffectButton != "") {
        instance_destroy(instanceEffectButton);
        instanceEffectButton = "";
    }

    // Déverrouillage différé: géré dans Step_0 (évite le clic traversant)
    // Ne pas modifier global.isActionMenuOpen ici
}
#endregion


// displayPositionButton and hidePositionButton removed for HS transition


#region Function displayAttackButton
displayAttackButton = function(card) {show_debug_message("### oUIManager.displayAttackButton")
    // Garde phase/joueur/type/zone/orientation pour éviter l'affichage sur des cartes non éligibles
    if (!(instance_exists(game) && game.is_local_turn && game.phase[game.phase_current] == "Main")) {
        show_debug_message("### UIManager.displayAttackButton: hors phase Main ou pas tour du héros");
        return;
    }
    // Règle: pas d'attaque au tour 1 du duel
    if (variable_instance_exists(game, "nbTurn") && game.nbTurn == 1) {
        show_debug_message("### UIManager.displayAttackButton: Attaque interdite au tour 1 -> bouton non affiché");
        return;
    }
    if (card == noone || !instance_exists(card)) {
        show_debug_message("### UIManager.displayAttackButton: carte invalide");
        return;
    }
    if (!(variable_instance_exists(card, "type") && card.type == "Monster")) {
        show_debug_message("### UIManager.displayAttackButton: carte non-monstre -> bouton non affiché");
        return;
    }
    if (!(variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner)) {
        show_debug_message("### UIManager.displayAttackButton: carte non-héros -> bouton non affiché");
        return;
    }
    if (!(variable_instance_exists(card, "zone") && (card.zone == "Field" || card.zone == "FieldSelected"))) {
        show_debug_message("### UIManager.displayAttackButton: carte hors terrain -> bouton non affiché");
        return;
    }
    if (!(variable_instance_exists(card, "orientation") && card.orientation == "Attack")) {
        show_debug_message("### UIManager.displayAttackButton: carte non orientée en Attaque -> bouton non affiché");
        return;
    }

    if (variable_instance_exists(card, "entrave_turns_remaining") && card.entrave_turns_remaining > 0 && variable_instance_exists(card, "entrave_block_attack") && card.entrave_block_attack) {
        show_debug_message("### UIManager.displayAttackButton: carte entravée (attaque) -> bouton non affiché");
        return;
    }

    // Limite d'attaques par tour (2 si ambidextre, sinon 1)
    var attack_limit = 1;
    if (variable_instance_exists(card, "isAmbidextrous") && card.isAmbidextrous) {
        attack_limit = 2;
    }
    var used_attacks = (variable_instance_exists(card, "attacksUsedThisTurn") ? card.attacksUsedThisTurn : 0);
    if (used_attacks >= attack_limit) {
        show_debug_message("### UIManager.displayAttackButton: limite d'attaques atteinte -> bouton non affiché");
        return;
    }

    // Cache le bouton précédent s'il existe
    if(instanceAttackButton != "") {
        instance_destroy(instanceAttackButton);
    }
    
    // Calcule la hauteur de la carte sur le terrain pour positionner le bouton au-dessus
    var sprite_h = sprite_get_height(card.sprite_index) * card.image_yscale;
    
    // Place le bouton au-dessus de la carte sur le terrain
    instanceAttackButton = instance_create_layer(card.x, card.y - sprite_h/2 - 60, layer_get_id("Instances"), oAttack);
    instanceAttackButton.parentCard = card;
    instanceAttackButton.depth = -2000;
    instanceAttackButton.visible = true;
    instanceAttackButton.image_alpha = 1.0;
    
    // Activer le blocage pendant l'affichage du bouton d'attaque
    global.isActionMenuOpen = true;
    
}
#endregion

#region Function displayEffectButton
// Affiche le bouton effet uniquement si un effet manuel disponible
// et nettoie tout bouton résiduel si aucun effet n’est disponible
displayEffectButton = function(card) {show_debug_message("### oUIManager.displayEffectButton")
    // Nettoyer tout ancien bouton effet
    if (instanceEffectButton != "" && instance_exists(instanceEffectButton)) {
        instance_destroy(instanceEffectButton);
        instanceEffectButton = "";
    }

    // Vérifier la disponibilité d'un effet manuel
    if (card != noone && instance_exists(card)) {
        // Règle UI: les cartes de genre "Secret" n'affichent jamais le bouton effet
        // MODIFICATION: Autoriser l'affichage du bouton pour les Secrets, MAIS appliquer les règles de limite (5 max, pas de doublon)
        if (variable_instance_exists(card, "genre") && string_lower(card.genre) == string_lower("Secret")) {
            if (variable_global_exists("activeSecretsHero") && ds_exists(global.activeSecretsHero, ds_type_list)) {
                // 1. Limite Max 5
                if (ds_list_size(global.activeSecretsHero) >= 5) {
                    show_debug_message("### oUIManager.displayEffectButton: Secret caché (Max 5 atteints)");
                    return;
                }
                // 2. Pas de doublon
                var cardName = variable_instance_exists(card, "name") ? card.name : "";
                for (var i = 0; i < ds_list_size(global.activeSecretsHero); i++) {
                    var existing = ds_list_find_value(global.activeSecretsHero, i);
                    if (instance_exists(existing) && variable_instance_exists(existing, "name") && existing.name == cardName) {
                        show_debug_message("### oUIManager.displayEffectButton: Secret caché (Déjà actif: " + string(cardName) + ")");
                        return;
                    }
                }
            }
        }

        // États utiles
        var isFD = (variable_instance_exists(card, "isFaceDown") && card.isFaceDown);
        var isOnField = (variable_instance_exists(card, "zone") && (card.zone == "Field" || card.zone == "FieldSelected"));
        var isInHand = (variable_instance_exists(card, "zone") && (card.zone == "Hand" || card.zone == "HandSelected"));
        var isOwnerHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
        var isArtifact = (variable_instance_exists(card, "genre") && card.genre == "Artéfact");
        var isHeroTurn = false;
        if (instance_exists(game)) {
            if (variable_global_exists("NET_MODE") && global.NET_MODE != "offline") {
                isHeroTurn = game.is_local_turn;
            } else {
                isHeroTurn = (game.player_current == 0);
            }
        }
        var currentPhase = (instance_exists(game) && variable_instance_exists(game, "phase")) ? game.phase[game.phase_current] : "";
        // Détection d'au moins un effet continu
        var hasContinuous = false;
        if (variable_instance_exists(card, "effects")) {
            for (var ci = 0; ci < array_length(card.effects); ci++) {
                var ce = card.effects[ci];
                if (is_struct(ce) && variable_struct_exists(ce, "trigger") && ce.trigger == TRIGGER_CONTINUOUS) { hasContinuous = true; break; }
            }
        }
        if (variable_instance_exists(card, "genre")) {
            var gl = string_lower(card.genre);
            if (gl == "continu" || gl == "continue") { hasContinuous = true; }
        }

        // NOUVELLE RÈGLE: n'afficher le bouton que si au moins 1 monstre face visible est présent (OBSOLÈTE pour Artéfact)
        /*
        if (isArtifact && !has_any_monster_on_field()) {
            show_debug_message("### oUIManager.displayEffectButton: aucun monstre face visible -> bouton masqué (Artéfact)");
            return;
        }
        */

        // Cas spécial: carte face cachée sur le terrain du héros
        // Afficher le bouton si une cible valide existe pour un effet manuel OU si la carte possède un effet continu (pour permettre le retournement)
        if (isFD && isOnField && isOwnerHero) {
            var effectFD = getAvailableEffect(card);
            var allowFD = false;
            if (effectFD != noone && hasValidTargetForEffect(card, effectFD)) {
                allowFD = true;
            } else if (hasContinuous) {
                allowFD = true;
            }
            // Affichage uniquement pendant le tour du héros et en phase "Main"
            if (allowFD && isHeroTurn && currentPhase == "Main") {
                var sprite_h_fd = sprite_get_height(card.sprite_index) * card.image_yscale;
                instanceEffectButton = instance_create_layer(card.x + 85, card.y - sprite_h_fd/2 + 5, layer_get_id("Instances"), oEffectButton);
                instanceEffectButton.parentCard = card;
                instanceEffectButton.depth = -2000;
                instanceEffectButton.image_xscale = 0.4;
                instanceEffectButton.image_yscale = 0.4;
                global.isActionMenuOpen = true;
            } else {
                show_debug_message("### oUIManager.displayEffectButton: aucune cible valide pour carte face cachée (et pas d'effet continu)");
            }
            return;
        }

        // Carte Magie en main -> afficher le bouton "Activer" (Play)
        // (Remplaçant l'ancien bouton Summon pour les magies)
        if (card.type == "Magic" && isInHand && isOwnerHero && isHeroTurn && currentPhase == "Main") {
             // Position centrée (comme l'ancien bouton Summon) car c'est le seul bouton
            if (instanceEffectButton == "" || !instance_exists(instanceEffectButton)) {
                instanceEffectButton = instance_create_layer(card.x, card.y - 280, layer_get_id("Instances"), oEffectButton);
                instanceEffectButton.parentCard = card;
                instanceEffectButton.depth = -2000;
                instanceEffectButton.image_xscale = 0.5; // Un peu plus gros comme c'est l'action principale
                instanceEffectButton.image_yscale = 0.5;
                global.isActionMenuOpen = true;
            }
            return;
        }

        // Carte Magie en main avec effet continu (Legacy/Backup si condition ci-dessus échoue pour une raison quelconque)
        if (card.type == "Magic" && isInHand && isOwnerHero && hasContinuous && isHeroTurn) {
            // OBSOLÈTE: La logique Artéfact a été supprimée
            /*
            // Si la carte est un Artéfact avec sélection de cible, n'afficher le bouton que s'il existe une cible valide
            var equipEff = noone;
            if (variable_instance_exists(card, "effects")) {
                for (var ei = 0; ei < array_length(card.effects); ei++) {
                    var efx = card.effects[ei];
                    if (is_struct(efx) && variable_struct_exists(efx, "effect_type") && efx.effect_type == EFFECT_EQUIP_SELECT_TARGET) {
                        equipEff = efx; break;
                    }
                }
            }
            if (equipEff != noone && !hasValidTargetForEffect(card, equipEff)) {
                show_debug_message("### oUIManager.displayEffectButton: aucune cible valide pour Artefact en main -> bouton masqué");
                return;
            }
            */
            var sprite_h_c = sprite_get_height(card.sprite_index) * card.image_yscale;
            instanceEffectButton = instance_create_layer(card.x + 85, card.y - sprite_h_c/2 + 5, layer_get_id("Instances"), oEffectButton);
            instanceEffectButton.parentCard = card;
            instanceEffectButton.depth = -2000;
            instanceEffectButton.image_xscale = 0.5;
            instanceEffectButton.image_yscale = 0.5;
            global.isActionMenuOpen = true;
            return;
        }

        // Affichage standard si un effet est disponible ET au moins une cible valide
        var effect = getAvailableEffect(card);
        if (effect != noone && hasValidTargetForEffect(card, effect)) {
            // Autoriser l'affichage seulement pendant le tour du héros et en phase Main,
            // sauf pour les effets rapides (TRIGGER_QUICK_EFFECT) qui peuvent s'afficher à tout moment du tour du héros
            var isQuick = (variable_struct_exists(effect, "trigger") && effect.trigger == TRIGGER_QUICK_EFFECT);
            if (!(isQuick || (isHeroTurn && currentPhase == "Main"))) {
                show_debug_message("### oUIManager.displayEffectButton: hors tour/phase -> bouton masqué");
                return;
            }
            var sprite_h = sprite_get_height(card.sprite_index) * card.image_yscale;
            instanceEffectButton = instance_create_layer(card.x + 85, card.y - sprite_h/2 + 5, layer_get_id("Instances"), oEffectButton);
            instanceEffectButton.parentCard = card;
            instanceEffectButton.depth = -2000;
            instanceEffectButton.image_xscale = 0.5;
            instanceEffectButton.image_yscale = 0.5;

            global.isActionMenuOpen = true;
        } else {
            show_debug_message("### oUIManager.displayEffectButton: effet indisponible ou aucune cible valide pour cette carte");
        }
    }
}
#endregion

#region Function hideEffectButton
hideEffectButton = function() {show_debug_message("### oUIManager.hideEffectButton")
    if (instanceEffectButton != "") {
        instance_destroy(instanceEffectButton);
        instanceEffectButton = "";
    }
    // Déverrouillage différé: géré dans Step_0
    // Ne pas modifier global.isActionMenuOpen ici
}
#endregion


#region Function hideAttackButton
hideAttackButton = function() {show_debug_message("### oUIManager.hideAttackButton")
    if (instanceAttackButton != "") {
        instance_destroy(instanceAttackButton);
        instanceAttackButton = "";
    }
    
    // Déverrouillage différé: géré dans Step_0
    // Ne pas modifier global.isActionMenuOpen ici
}
#endregion

#region Function displayIndicator
displayIndicator = function(cardToDisplay = noone) {show_debug_message("### oUIManager.displayIndicator")
	
	var card = (cardToDisplay != noone) ? cardToDisplay : selectManager.selected;
	if (card == noone) {
		show_debug_message("Erreur: Aucune carte à afficher pour les indicateurs");
		return;
	}
	
	hideSummonAndSet(); // Cache les boutons d'actions
	// Sécuriser l'accès au fieldManagerHero pour restaurer le flux d'avant
	var fm = instance_exists(fieldManagerHero) ? fieldManagerHero : instance_find(oFieldManagerHero, 0);
	if (fm != noone && instance_exists(fm)) {
		fm.addIndicators(card.type); // Ajoute les indicateurs au sol (côté Monstre ou Magique/Piège suivant la carte)
	} else {
		show_debug_message("Erreur: fieldManagerHero introuvable ou détruit pour addIndicators");
		return;
	}
	// Ajuste la position prévue selon le mode
	if (card.type == "Magic" && selectedSummonOrSet == "Set") {
		card.position = "Attack"; // Set Magie: face cachée mais en position Attaque
	} else {
		card.position = selectedSummonOrSet == "Summon" ? "Attack" : "PV";
	}
	selectManager.unSelect(card); // Replace la carte sélectionnée
	selectManager.set(card); // Conserver la sélection pour retrouver la carte à invoquer
}
#endregion

// Vérifie si le Cheval de la Rose Noire peut être invoqué spécialement depuis la main
canSpecialSummonRoseCheval = function(card) {
    if (card == noone || !instance_exists(card)) return false;
    if (card.zone != "Hand" || !card.isHeroOwner) return false;
    if (game.phase[game.phase_current] != "Summon") return false;
    var isLocalTurn = false;
    if (instance_exists(game)) {
        if (variable_global_exists("NET_MODE") && global.NET_MODE != "offline") {
            isLocalTurn = game.is_local_turn;
        } else {
            isLocalTurn = (game.player[game.player_current] == "Hero");
        }
    }
    if (!isLocalTurn) return false;
    if (object_get_name(card.object_index) != "oChevalDeLaRoseNoire") return false;
    return has_archetype_monster_on_field(true, "Rose noire");
}


#region Function stopIndicator
stopIndicator = function() {show_debug_message("### oUIManager.stopIndicator")
	
	// La carte n'est plus en cours de traitement
	selectedSummonOrSet = "";
	
	// Détruit tous les indicateurs
	var nbInstance = instance_number(oIndicatorParent);
	for(var i = 0; i < nbInstance; ++i;)
	    instance_destroy(instance_find(oIndicatorParent, 0));
}
#endregion


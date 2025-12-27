/// sEffectMisc.gml — Helpers divers (filtres, bannissement, retour en main, descriptions, boosts, magies)

/// @function banishCard(card)
function banishCard(card) {
    if (card == noone) return false;
    if (!instance_exists(card)) return false;
    var wasOnField = (variable_instance_exists(card, "zone") && (card.zone == "Field" || card.zone == "FieldSelected"));
    if (wasOnField) { registerTriggerEvent(TRIGGER_LEAVE_FIELD, card, {}); }
    card.zone = "Banished";
    instance_destroy(card);
    return true;
}

/// @function returnToHand(card)
function returnToHand(card) {
    if (card == noone || !instance_exists(card) || !instance_exists(oHand)) return false;
    var isOnField = (variable_instance_exists(card, "zone") && (card.zone == "Field" || card.zone == "FieldSelected"));
    if (!isOnField) return false;
    registerTriggerEvent(TRIGGER_LEAVE_FIELD, card, {});
    var fm = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner) ? fieldManagerHero : fieldManagerEnemy;
    if (instance_exists(fm) && variable_instance_exists(card, "fieldPosition")) { fm.remove(card); }
    var h = noone; with (oHand) { if (variable_instance_exists(self, "isHeroOwner") && (isHeroOwner == card.isHeroOwner)) { h = id; break; } }
    if (h == noone) return false;
    h.addCard(card);
    card.zone = "Hand";
    registerTriggerEvent(TRIGGER_ENTER_HAND, card, { owner_is_hero: (variable_instance_exists(card, "isHeroOwner") ? card.isHeroOwner : true) });
    return true;
}

/// @function getTargetsByFilter(effect)
function getTargetsByFilter(effect) {
    var targets = [];
    var targetZone = "field";
    var zonesArr = [];
    var zoneIsArray = false;
    var includeHand = false;
    var ownerFilter = "both";
    var includeGraveyard = false;
    var hasMonsterType = false;
    var monsterTypeLower = "";
    var criteria = noone;
    if (is_struct(effect)) {
        if (variable_struct_exists(effect, "target_zone")) {
            if (is_array(effect.target_zone)) {
                zoneIsArray = true;
                var tz = effect.target_zone;
                zonesArr = array_create(array_length(tz));
                for (var zi = 0; zi < array_length(tz); zi++) { zonesArr[zi] = string_lower(tz[zi]); }
            } else {
                targetZone = string_lower(effect.target_zone);
            }
        }
        if (variable_struct_exists(effect, "include_hand")) includeHand = effect.include_hand;
        if (variable_struct_exists(effect, "owner")) ownerFilter = string_lower(effect.owner);
        if (variable_struct_exists(effect, "include_graveyard")) includeGraveyard = effect.include_graveyard;
        if (variable_struct_exists(effect, "monster_type")) { hasMonsterType = true; monsterTypeLower = string_lower(effect.monster_type); }
        if (variable_struct_exists(effect, "criteria")) criteria = effect.criteria;
        if (criteria != noone) {
            if (variable_struct_exists(effect, "genre") && !variable_struct_exists(criteria, "genre")) criteria.genre = effect.genre;
            if (variable_struct_exists(effect, "type") && !variable_struct_exists(criteria, "type")) criteria.type = effect.type;
        }
    }
    with (oCardMonster) {
        var isValidTarget = true;
        var zoneLower = variable_instance_exists(self, "zone") ? string_lower(zone) : "";
        var inZone = false;
        if (zoneIsArray) {
            for (var zj = 0; zj < array_length(zonesArr); zj++) {
                var zwant = zonesArr[zj];
                if ((zwant == "field" && (zoneLower == "field" || zoneLower == "fieldselected"))
                    || (zwant == "hand" && zoneLower == "hand")) { inZone = true; break; }
            }
        } else {
            if (targetZone == "all") { inZone = (zoneLower == "field" || zoneLower == "fieldselected" || (includeHand && zoneLower == "hand")); }
            else if (targetZone == "field") { inZone = (zoneLower == "field" || zoneLower == "fieldselected"); }
            else if (targetZone == "hand") { inZone = (zoneLower == "hand"); }
            else { inZone = (zoneLower == targetZone); }
        }
        if (!inZone) isValidTarget = false;
        if (isValidTarget && ownerFilter != "both") {
            var isHero = variable_instance_exists(self, "isHeroOwner") ? isHeroOwner : undefined;
            if (ownerFilter == "hero" && !isHero) isValidTarget = false;
            if (ownerFilter == "enemy" && isHero) isValidTarget = false;
        }
        if (isValidTarget && hasMonsterType) {
            if (!variable_instance_exists(self, "type") || string_lower(type) != monsterTypeLower) { isValidTarget = false; }
        }
        var isMass = (is_struct(effect) && variable_struct_exists(effect, "scope") && string_lower(effect.scope) == "all");
        var isRandom = (is_struct(effect) && variable_struct_exists(effect, "random_select") && effect.random_select);
        if (isValidTarget && !isMass && !isRandom && ownerFilter == "enemy") {
            if (variable_instance_exists(self, "isCamouflage") && self.isCamouflage) { isValidTarget = false; }
        }
        if (isValidTarget && criteria != noone) {
            if (!_cardMatchesCriteria(self, criteria)) { isValidTarget = false; }
        }
        if (isValidTarget) { array_push(targets, self); }
    }
    {
        var addGY = false;
        if (zoneIsArray) {
            for (var zg = 0; zg < array_length(zonesArr); zg++) { if (zonesArr[zg] == "graveyard") { addGY = true; break; } }
        } else {
            addGY = (targetZone == "graveyard" || targetZone == "all");
        }
        if (addGY) {
            var critLocal = {};
            if (is_struct(effect) && variable_struct_exists(effect, "criteria")) critLocal = effect.criteria;
            if (ownerFilter == "both" || ownerFilter == "hero") {
                var gyH = variable_global_exists("graveyardHero") ? global.graveyardHero : noone;
                if (instance_exists(gyH) && variable_instance_exists(gyH, "cards")) {
                    var arrH = gyH.cards;
                    for (var i = 0; i < array_length(arrH); i++) {
                        var cdH = arrH[i];
                        if (cdH != noone && _cardMatchesCriteria(cdH, critLocal)) {
                            if (ownerFilter == "hero") {
                                if (variable_struct_exists(cdH, "isHeroOwner") && cdH.isHeroOwner) { array_push(targets, cdH); }
                            } else { array_push(targets, cdH); }
                        }
                    }
                }
            }
            if (ownerFilter == "both" || ownerFilter == "enemy") {
                var gyE = variable_global_exists("graveyardEnemy") ? global.graveyardEnemy : noone;
                if (instance_exists(gyE) && variable_instance_exists(gyE, "cards")) {
                    var arrE = gyE.cards;
                    for (var j = 0; j < array_length(arrE); j++) {
                        var cdE = arrE[j];
                        if (cdE != noone && _cardMatchesCriteria(cdE, critLocal)) {
                            if (ownerFilter == "enemy") {
                                if (variable_struct_exists(cdE, "isHeroOwner") && !cdE.isHeroOwner) { array_push(targets, cdE); }
                            } else { array_push(targets, cdE); }
                        }
                    }
                }
            }
        }
    }
    return targets;
}

/// @function hasValidTargetForEffect(card, effect)
/// @description Retourne true si un effet ciblé possède au moins une cible valide selon ses règles
/// @param {instance} card - La carte source (utilisée pour les restrictions d’allégeance)
/// @param {struct} effect - L’effet à vérifier
/// @returns {bool}
function hasValidTargetForEffect(card, effect) {
    if (effect == noone) return false;
    var etype = variable_struct_exists(effect, "effect_type") ? effect.effect_type : "";

    // Garde spécifique Artefact: si déjà équipé à une cible, ne pas proposer de nouvelle cible
    if (etype == EFFECT_EQUIP_SELECT_TARGET) {
        if (instance_exists(card) && variable_instance_exists(card, "equipped_target") && card.equipped_target != noone) {
            if (instance_exists(card.equipped_target)) {
                return false;
            }
        }
    }

    // Liste des effets nécessitant une cible manuelle
    var scope_lower = string_lower(variable_struct_exists(effect, "scope") ? effect.scope : "single");
    var needsTarget = (
                        etype == EFFECT_DESTROY_TARGET
                        || etype == EFFECT_BANISH_TARGET
                        || etype == EFFECT_RETURN_TO_HAND
                        || etype == EFFECT_EQUIP_SELECT_TARGET
                        || (etype == EFFECT_SUMMON && string_lower(variable_struct_exists(effect, "summon_mode") ? effect.summon_mode : "") == "copy_target")
                        || (etype == EFFECT_BUFF && scope_lower == "single")
                        || (etype == EFFECT_ENTRAVE && scope_lower == "single")
                        || (etype == EFFECT_CAMOUFLAGE && scope_lower == "single")
                        || (etype == EFFECT_POINTS && string_lower(variable_struct_exists(effect, "scope") ? effect.scope : "lp") == "card" && string_lower(variable_struct_exists(effect, "select_mode") ? effect.select_mode : "filter") == "target")
                       );

    // Cas non-ciblé: certains effets ont tout de même des prérequis bloquants
    if (!needsTarget) {
        // Garde spécifique: EFFECT_DESTROY doit vérifier qu'une cible existe selon critères avant d'afficher le bouton
        if (etype == EFFECT_DESTROY) {
            return isEffectActivatable(card, effect);
        }
        // Vérifier les prérequis d'effets non-ciblés connus qui ne doivent pas afficher le bouton si non satisfaits
        // 1) Fin de tour: défausser 1 puis détruire 1 Magie ennemie
        if (etype == EFFECT_END_DISCARD_DESTROY_ENEMY_SPELL) {
            var ownerIsHero_nd = (instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
            // Besoin d'au moins une Magie ennemie sur le terrain
            if (!hasEnemySpellOnField(ownerIsHero_nd)) return false;
            // Besoin d'au moins 1 carte en main du bon propriétaire
            var handInst = ownerIsHero_nd ? handHero : handEnemy;
            var handHasCard = (instance_exists(handInst) && variable_instance_exists(handInst, "cards") && ds_list_size(handInst.cards) > 0);
            if (!handHasCard) return false;
            return true;
        }
        // Par défaut pour les autres effets non-ciblés: autoriser l'affichage
        return true;
    }

    // Cas général: déléguer au validateur unifié
    if (etype != EFFECT_EQUIP_SELECT_TARGET) {
        return isEffectActivatable(card, effect);
    }

    // Cas spécifique: sélection de cible pour équipement (Artefact)
    if (etype == EFFECT_EQUIP_SELECT_TARGET) {
        var ownerIsHero = (instance_exists(card) && variable_instance_exists(card, "isHeroOwner")) ? card.isHeroOwner : true;
        var allyOnly = variable_struct_exists(effect, "ally_only") ? effect.ally_only : false;
        var allowedGenres = variable_struct_exists(effect, "allowed_genres") ? effect.allowed_genres : undefined;
        var found = false;
        with (oCardMonster) {
            if (!instance_exists(self)) continue;
            if (!(variable_instance_exists(self, "zone") && (zone == "Field" || zone == "FieldSelected"))) continue;
            // Interdire cible en défense face cachée
            if (variable_instance_exists(self, "orientation") && variable_instance_exists(self, "isFaceDown")) {
                if (orientation == "Defense" && isFaceDown) continue;
            }
            // Restriction allégeance
            if (allyOnly) {
                if (!(variable_instance_exists(self, "isHeroOwner") && isHeroOwner == ownerIsHero)) continue;
            }
            // Restriction de genre
            if (allowedGenres != undefined) {
                var g = variable_instance_exists(self, "genre") ? self.genre : "";
                var genreOk = false;
                if (is_array(allowedGenres)) {
                    for (var gi = 0; gi < array_length(allowedGenres); gi++) {
                        if (g == allowedGenres[gi]) { genreOk = true; break; }
                    }
                } else if (is_string(allowedGenres)) {
                    genreOk = (g == allowedGenres);
                } else {
                    genreOk = true;
                }
                if (!genreOk) continue;
            }
            found = true;
            break;
        }
        return found;
    }

    // (Cas composite Floraison supprimé)

    // (Obsolète supprimé) utiliser hasValidTargetForEffect via EFFECT_DESTROY et critères


    return false;
}

/// @function isEffectActivatable(card, effect)
/// @description Valide de manière unifiée si un effet a des cibles/conditions satisfaites
/// @param {instance} card - La carte source (pour les restrictions d’allégeance)
/// @param {struct} effect - L’effet à vérifier
/// @returns {bool}
function isEffectActivatable(card, effect) {
    if (effect == noone) return false;
    
    // 1. Vérification des conditions génériques (Once per turn, LP, Main, Phase...)
    // On utilise checkTriggerConditions si disponible pour valider les prérequis non-ciblés
    if (!is_undefined(asset_get_index("checkTriggerConditions"))) {
        // Contexte vide car on vérifie l'activabilité "à froid"
        if (!checkTriggerConditions(card, effect, {})) return false;
    }
    
    var etype = variable_struct_exists(effect, "effect_type") ? effect.effect_type : "";

    // Sélection d’équipement (Artefact)
    if (etype == EFFECT_EQUIP_SELECT_TARGET) {
        var ownerIsHero = true;
        if (is_struct(card)) {
            if (variable_struct_exists(card, "isHeroOwner")) ownerIsHero = card.isHeroOwner;
        } else if (instance_exists(card)) {
            if (variable_instance_exists(card, "isHeroOwner")) ownerIsHero = card.isHeroOwner;
        }
        
        var allyOnly = variable_struct_exists(effect, "ally_only") ? effect.ally_only : false;
        var allowedGenres = variable_struct_exists(effect, "allowed_genres") ? effect.allowed_genres : undefined;
        var foundEquip = false;
        with (oCardMonster) {
            if (!instance_exists(self)) continue;
            if (!(variable_instance_exists(self, "zone") && (zone == "Field" || zone == "FieldSelected"))) continue;
            if (variable_instance_exists(self, "orientation") && variable_instance_exists(self, "isFaceDown")) {
                if (orientation == "Defense" && isFaceDown) continue;
            }
            if (allyOnly) {
                if (!(variable_instance_exists(self, "isHeroOwner") && isHeroOwner == ownerIsHero)) continue;
            }
            if (allowedGenres != undefined) {
                var g = variable_instance_exists(self, "genre") ? self.genre : "";
                var genreOk = false;
                if (is_array(allowedGenres)) {
                    for (var gi = 0; gi < array_length(allowedGenres); gi++) {
                        if (g == allowedGenres[gi]) { genreOk = true; break; }
                    }
                } else if (is_string(allowedGenres)) {
                    genreOk = (g == allowedGenres);
                } else {
                    genreOk = true;
                }
                if (!genreOk) continue;
            }
            foundEquip = true;
            break;
        }
        return foundEquip;
    }

    // Destruction moderne avec critères
    if (etype == EFFECT_DESTROY && variable_struct_exists(effect, "criteria")) {
        var ownerIsHero_dm = true;
        if (is_struct(card)) {
            if (variable_struct_exists(card, "isHeroOwner")) ownerIsHero_dm = card.isHeroOwner;
        } else if (instance_exists(card)) {
            if (variable_instance_exists(card, "isHeroOwner")) ownerIsHero_dm = card.isHeroOwner;
        }
        
        var ownerFilter = variable_struct_exists(effect, "owner") ? effect.owner : "both";
        var targetZone = variable_struct_exists(effect, "target_zone") ? string_lower(effect.target_zone) : "field";
        var foundDestroy = false;
        with (oCardMonster) {
            if (!instance_exists(self)) continue;
            var zoneLower = variable_instance_exists(self, "zone") ? string_lower(zone) : "";
            if (targetZone == "field" && zoneLower != "field") continue;
            if (targetZone == "hand" && zoneLower != "hand") continue;
            if (targetZone != "all" && targetZone != "field" && targetZone != "hand" && zoneLower != targetZone) continue;
            if (ownerFilter != "both") {
                var isHero = variable_instance_exists(self, "isHeroOwner") ? isHeroOwner : undefined;
                if (ownerFilter == "ally" && isHero != ownerIsHero_dm) continue;
                if (ownerFilter == "enemy" && isHero == ownerIsHero_dm) continue;
            }
            if (_cardMatchesCriteria(self, effect.criteria)) {
                foundDestroy = true;
                break;
            }
        }
        return foundDestroy;
    }

    // Fallback standard via filtre générique
    var targets = getTargetsByFilter(effect);
    return array_length(targets) > 0;
}

/// @function negateEffect(targetEffect)
function negateEffect(targetEffect) {
    if (targetEffect == noone) return false;
    targetEffect.negated = true;
    show_debug_message("Effet annulé : " + string(targetEffect.effect_type));
    return true;
}

/// @function resetTemporaryEffects()
function resetTemporaryEffects() {
    with (oCardMonster) {
        if (variable_struct_exists(self, "temp_attack")) { temp_attack = 0; }
        if (variable_struct_exists(self, "temp_defense")) { temp_defense = 0; }
    }
}

/// @function getEffectDescription(effect)
function getEffectDescription(effect) {
    if (variable_struct_exists(effect, "description")) { return effect.description; }
    var desc = "";
    var value = variable_struct_exists(effect, "value") ? effect.value : 0;
    switch(effect.effect_type) {
        case EFFECT_DRAW_CARDS:
            desc = "Piochez " + string(value) + " carte" + (value > 1 ? "s" : "");
            break;
        case EFFECT_POINTS:
            var scope = variable_struct_exists(effect, "scope") ? string_lower(effect.scope) : "lp";
            var op = variable_struct_exists(effect, "op") ? string_lower(effect.op) : "damage";
            var val = value;
            if (variable_struct_exists(effect, "value")) val = effect.value;
            else if (variable_struct_exists(effect, "amount")) val = effect.amount;
            else if (variable_struct_exists(effect, "damage")) val = effect.damage;
            else if (variable_struct_exists(effect, "heal")) val = effect.heal;
            if (scope == "lp") {
                var verb = (op == "heal") ? "Soignez" : "Infligez";
                desc = verb + " " + string(val) + " LP";
            } else {
                var verb2 = (op == "heal") ? "Soignez" : "Infligez";
                desc = verb2 + " " + string(val) + " point" + ((val > 1) ? "s" : "") + " à une carte";
            }
            break;
        case EFFECT_BUFF:
            var a = variable_struct_exists(effect, "atk") ? effect.atk : (variable_struct_exists(effect, "value") ? effect.value : 0);
            var d = variable_struct_exists(effect, "def") ? effect.def : 0;
            var parts = [];
            if (a != 0) array_push(parts, "+" + string(a) + " ATK");
            if (d != 0) array_push(parts, "+" + string(d) + " DEF");
            var txt = (array_length(parts) > 0) ? string_join(parts, " / ") : "Buff";
            desc = txt;
            break;
        
        default:
            desc = "Effet : " + effect.effect_type;
    }
    return desc;
}



/// @function hasEnemySpellOnField(ownerIsHero)
/// @description Vérifie s'il existe au moins une carte de type Magic sur le terrain adverse
function hasEnemySpellOnField(ownerIsHero) {
    var found = false;
    // Parcourir toutes les cartes parents pour couvrir les objets enfants de oCardMagic
    with (oCardParent) {
        if (!instance_exists(self)) continue;
        if (!variable_instance_exists(self, "zone")) continue;
        // Accepter "Field" et "FieldSelected" comme présents sur le terrain
        var onField = (zone == "Field" || zone == "FieldSelected");
        if (!onField) continue;
        // Limiter aux cartes de type Magic
        if (!variable_instance_exists(self, "type") || string_lower(self.type) != string_lower("Magic")) continue;
        // S'assurer que l'allégeance est adverse par rapport au propriétaire de l'effet
        if (!variable_instance_exists(self, "isHeroOwner")) continue;
        if (self.isHeroOwner == ownerIsHero) continue;
        found = true;
        // Petite optimisation: sortir dès qu'on a trouvé
        break;
    }
    return found;
}

/// @function destroyOneEnemySpell(ownerIsHero)
function destroyOneEnemySpell(ownerIsHero) {
    var targetSpell = noone;
    with (oCardMagic) {
        if (targetSpell == noone && zone == "Field" && variable_instance_exists(self, "isHeroOwner") && (isHeroOwner != ownerIsHero)) {
            targetSpell = id;
        }
    }
    if (targetSpell != noone) {
        return destroyCard(targetSpell);
    }
    return false;
}

/// @function destroyRandomEnemySpell(ownerIsHero)
/// @description Détruit aléatoirement une carte de type Magic sur le terrain adverse
function destroyRandomEnemySpell(ownerIsHero) {
    var candidates = [];
    // Parcourir toutes les cartes parents pour inclure les enfants de oCardMagic
    with (oCardParent) {
        if (!instance_exists(self)) continue;
        if (!variable_instance_exists(self, "zone")) continue;
        var onField = (zone == "Field" || zone == "FieldSelected");
        if (!onField) continue;
        if (!variable_instance_exists(self, "type") || string_lower(self.type) != string_lower("Magic")) continue;
        if (!variable_instance_exists(self, "isHeroOwner")) continue;
        if (self.isHeroOwner == ownerIsHero) continue;
        array_push(candidates, id);
    }
    var n = array_length(candidates);
    if (n > 0) {
        var idx = irandom(n - 1);
        var pick = candidates[idx];
        var ok = destroyCard(pick);
        if (!ok) {
            show_debug_message("### destroyRandomEnemySpell: échec destruction sur id=" + string(pick));
        }
        return ok;
    }
    show_debug_message("### destroyRandomEnemySpell: aucun sort adverse candidat à détruire");
    return false;
}


function applyDestroyRandomAlliedMonsterByGenreOnField(card, effect) {
    if (card == noone || !instance_exists(card)) return false;
    var ownerIsHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
    // Harmonisation: lire le genre depuis l'effet
    var genreWanted = variable_struct_exists(effect, "genre") ? effect.genre : "Bête";

    var candidates = [];
    with (oCardMonster) {
        if (instance_exists(self) && variable_instance_exists(self, "zone") && (zone == "Field" || zone == "FieldSelected")) {
            var sameSide = (variable_instance_exists(self, "isHeroOwner") ? (self.isHeroOwner == ownerIsHero) : false);
            if (sameSide && variable_instance_exists(self, "genre") && string_lower(self.genre) == string_lower(genreWanted)) {
                array_push(candidates, id);
            }
        }
    }

    var n = array_length(candidates);
    if (n <= 0) {
        show_debug_message("### Aucun monstre allié du genre '" + string(genreWanted) + "' à détruire.");
        return false;
    }
    var idx = irandom(n - 1);
    return destroyCard(candidates[idx]);
}

function applyDestroyRandomEnemyMonsterOnField(card, effect) {
    if (card == noone || !instance_exists(card)) return false;
    var ownerIsHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);

    var candidates = [];
    with (oCardMonster) {
        if (instance_exists(self) && variable_instance_exists(self, "zone") && (zone == "Field" || zone == "FieldSelected")) {
            var enemySide = (variable_instance_exists(self, "isHeroOwner") ? (self.isHeroOwner != ownerIsHero) : false);
            if (enemySide) {
                array_push(candidates, id);
            }
        }
    }

    var n = array_length(candidates);
    if (n <= 0) {
        show_debug_message("### Aucun monstre ennemi à détruire.");
        return false;
    }
    var idx = irandom(n - 1);
    return destroyCard(candidates[idx]);
}

/// @function applyDestroyBySpec(card, effect, context)
/// @description Destruction générique: sélectionne et détruit des cartes selon des critères.
/// Clés supportées dans `effect`:
/// - owner: "ally" | "enemy" | "both" (par défaut: "enemy")
/// - target_zone: "Field" | "Hand" | "Graveyard" | "All" (par défaut: "Field")
/// - target_types: array de types (ex: ["Monster", "Magic"]) (par défaut: ["Monster"]) 
/// - criteria: struct de critères (_cardMatchesCriteria: name, object_name, type, genre, archetype, star_eq)
/// - random_select: bool (sélection aléatoire sans remise)
/// - destroy_count | value: nombre de cartes à détruire (par défaut: 1)
/// - select_all: bool pour tout détruire parmi candidats
/// - select_mode: "self" | "target" | "filter" (par défaut: "filter")
function applyDestroyBySpec(card, effect, context) {
    if (card == noone || !instance_exists(card)) return false;

    var ownerIsHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);

    // Modes directs: self ou target
    var selectMode = variable_struct_exists(effect, "select_mode") ? string_lower(effect.select_mode) : "filter";
    if (selectMode == "self" || (variable_struct_exists(effect, "destroy_self") && effect.destroy_self)) {
        return destroyCard(card);
    }

    var target = noone;
    if (variable_struct_exists(context, "target") && instance_exists(context.target)) {
        target = context.target;
    } else if (variable_struct_exists(effect, "target") && instance_exists(effect.target)) {
        target = effect.target;
    }
    // Mode "target": détruire explicitement la cible si elle existe. Si elle n'existe plus, ne pas basculer en mode filtre.
    if (selectMode == "target") {
        if (target != noone && instance_exists(target)) {
            // Animation poison facultative avant destruction différée
            if (variable_struct_exists(effect, "visual_fx") && string_lower(effect.visual_fx) == "poison") {
                spawnPoisonFX(target, card);
                return true;
            }
            return destroyCard(target, card);
        } else {
            // Cible absente: ne rien faire
            return false;
        }
    }

    // Paramétrage des filtres
    var ownerFilter = variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "enemy";
    var zoneWanted = variable_struct_exists(effect, "target_zone") ? string_lower(effect.target_zone) : "field";
    var typesWanted = variable_struct_exists(effect, "target_types") ? effect.target_types : ["Monster"]; // par défaut, uniquement monstres
    var criteria = variable_struct_exists(effect, "criteria") ? effect.criteria : {};
    var randomSelect = variable_struct_exists(effect, "random_select") ? effect.random_select : false;
    var destroyCount = 1;
    if (variable_struct_exists(effect, "destroy_count")) destroyCount = effect.destroy_count;
    else if (variable_struct_exists(effect, "value")) destroyCount = effect.value;
    var selectAll = variable_struct_exists(effect, "select_all") ? effect.select_all : false;

    // Compat: si genre/type sont directement fournis au niveau de l'effet, les copier dans criteria
    if (variable_struct_exists(effect, "genre") && !variable_struct_exists(criteria, "genre")) criteria.genre = effect.genre;
    if (variable_struct_exists(effect, "type") && !variable_struct_exists(criteria, "type")) criteria.type = effect.type;

    // Collecte des candidats (toutes cartes parent pour couvrir Monstre/Magie)
    var candidates = [];
    with (oCardParent) {
        if (!instance_exists(self)) continue;
        if (!variable_instance_exists(self, "zone")) continue;
        var zl = string_lower(zone);
        var inZone = false;
        if (zoneWanted == "all") { inZone = (zl == "field" || zl == "fieldselected" || zl == "hand" || zl == "graveyard"); }
        else if (zoneWanted == "field") { inZone = (zl == "field" || zl == "fieldselected"); }
        else { inZone = (zl == zoneWanted); }
        if (!inZone) continue;

        // Filtre d’allégeance
        if (ownerFilter != "both") {
            if (!variable_instance_exists(self, "isHeroOwner")) continue;
            var sameSide = (isHeroOwner == ownerIsHero);
            if (ownerFilter == "ally" && !sameSide) continue;
            if (ownerFilter == "enemy" && sameSide) continue;
        }

        // Filtre de type
        var stype = variable_instance_exists(self, "type") ? self.type : "";
        var typeOk = false;
        if (is_array(typesWanted)) {
            for (var ti = 0; ti < array_length(typesWanted); ti++) {
                if (stype == typesWanted[ti]) { typeOk = true; break; }
            }
        } else if (is_string(typesWanted)) {
            typeOk = (stype == typesWanted);
        } else {
            typeOk = true;
        }
        if (!typeOk) continue;

        // Critères supplémentaires
        var matchOk = true;
        if (is_struct(criteria)) {
            matchOk = _cardMatchesCriteria(self, criteria);
        }
        if (!matchOk) continue;

        array_push(candidates, id);
    }

    var n = array_length(candidates);
    if (n <= 0) {
        show_debug_message("### applyDestroyBySpec: aucune carte candidate à détruire (owner=" + string(ownerFilter) + ", zone=" + string(zoneWanted) + ")");
        return false;
    }

    // Sélection et destruction
    if (selectAll) {
        for (var i = 0; i < n; i++) { destroyCard(candidates[i], card); }
        return true;
    }

    var toDestroy = min(destroyCount, n);
    if (randomSelect) {
        var used = [];
        for (var k = 0; k < toDestroy; k++) {
            var idx = irandom(n - 1);
            var already = false;
            for (var u = 0; u < array_length(used); u++) { if (used[u] == idx) { already = true; break; } }
            var tries = 0;
            while (already && tries < 10) {
                idx = irandom(n - 1);
                already = false;
                for (var u2 = 0; u2 < array_length(used); u2++) { if (used[u2] == idx) { already = true; break; } }
                tries++;
            }
            array_push(used, idx);
            destroyCard(candidates[idx], card);
        }
    } else {
        for (var j = 0; j < toDestroy; j++) { destroyCard(candidates[j], card); }
    }

    return true;
}

/// @function applyDestroyByFilter(card, effect)
/// @description Détruit des cartes selon des filtres et une sélection paramétrable
/// @param {instance} card - La carte qui déclenche l'effet
/// @param {struct} effect - L'effet contenant les filtres
/// @returns {bool} - true si au moins une carte détruite

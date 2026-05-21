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
    
    // Capture state before move
    var _sx = card.x;
    var _sy = card.y;
    var _spr = card.sprite_index;
    var _img = card.image_index;
    var _scale = card.image_xscale;
    
    h.addCard(card);
    card.zone = "Hand";
    
    if (variable_instance_exists(card, "buff_contribs")) card.buff_contribs = [];
    if (variable_instance_exists(card, "temp_attack")) card.temp_attack = 0;
    if (variable_instance_exists(card, "temp_defense")) card.temp_defense = 0;
    if (variable_instance_exists(card, "original_attack") && variable_instance_exists(card, "attack")) card.attack = card.original_attack;
    if (variable_instance_exists(card, "original_PV") && variable_instance_exists(card, "PV")) card.PV = card.original_PV;
    if (script_exists(asset_get_index("buffRecompute"))) {
        buffRecompute(card);
    } else {
        if (variable_instance_exists(card, "effective_attack") && variable_instance_exists(card, "attack")) card.effective_attack = card.attack;
        if (variable_instance_exists(card, "effective_defense") && variable_instance_exists(card, "PV")) card.effective_defense = card.PV;
    }
    if (variable_instance_exists(card, "max_hp") && variable_instance_exists(card, "PV")) card.max_hp = card.PV;
    if (variable_instance_exists(card, "current_hp") && variable_instance_exists(card, "max_hp")) card.current_hp = card.max_hp;
    
    // Create Visual Effect
    var fx = instance_create_layer(_sx, _sy, "UI", oFX_ReturnToHand);
    if (fx != noone) {
        fx.card_instance = card;
        fx.spriteGhost = _spr;
        fx.imageGhost = _img;
        fx.start_x = _sx;
        fx.start_y = _sy;
        fx.start_scale = _scale;
        fx.depth = -9999; // Ensure on top
    }
    
    // Hide card immediately (will be revealed by FX when done)
    card.visible = false;
    
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
    var onlyCamouflaged = false;
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
        if (variable_struct_exists(effect, "only_camouflaged")) onlyCamouflaged = effect.only_camouflaged;
        if (criteria != noone) {
            if (variable_struct_exists(effect, "genre") && !variable_struct_exists(criteria, "genre")) criteria.genre = effect.genre;
            if (variable_struct_exists(effect, "type") && !variable_struct_exists(criteria, "type")) criteria.type = effect.type;
        }
    }
    var sourceOwnerIsHero = undefined;
    if (is_struct(effect) && variable_struct_exists(effect, "source_card")) {
        var sc = effect.source_card;
        if (instance_exists(sc) && variable_instance_exists(sc, "isHeroOwner")) {
            sourceOwnerIsHero = sc.isHeroOwner;
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
            if (sourceOwnerIsHero != undefined) {
                var sameSide = (isHero == sourceOwnerIsHero);
                if (ownerFilter == "ally" && !sameSide) isValidTarget = false;
                if (ownerFilter == "enemy" && sameSide) isValidTarget = false;
            } else {
                if (ownerFilter == "hero" && !isHero) isValidTarget = false;
                if (ownerFilter == "enemy" && isHero) isValidTarget = false;
            }
        }
        if (isValidTarget && hasMonsterType) {
            if (!variable_instance_exists(self, "type") || string_lower(type) != monsterTypeLower) { isValidTarget = false; }
        }
        if (isValidTarget && onlyCamouflaged) {
            if (!variable_instance_exists(self, "isCamouflage") || !self.isCamouflage) { isValidTarget = false; }
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
    
    // Ajout: Vérification des Héros/Avatar comme cibles potentielles (si zone field incluse)
    var checkField = (targetZone == "all" || targetZone == "field" || targetZone == "fieldselected");
    if (zoneIsArray) {
        checkField = false;
        for (var z = 0; z < array_length(zonesArr); z++) {
            if (zonesArr[z] == "field" || zonesArr[z] == "fieldselected") { checkField = true; break; }
        }
    }

    if (checkField && !hasMonsterType) {
        var checkHero = (ownerFilter == "both" || ownerFilter == "hero");
        var checkEnemy = (ownerFilter == "both" || ownerFilter == "enemy");
        if (sourceOwnerIsHero != undefined) {
            if (ownerFilter == "ally") { checkHero = sourceOwnerIsHero; checkEnemy = !sourceOwnerIsHero; }
            else if (ownerFilter == "enemy") { checkHero = !sourceOwnerIsHero; checkEnemy = sourceOwnerIsHero; }
        }
        
        if (checkHero && instance_exists(oLP_Hero)) {
             var validH = true;
             if (criteria != noone && !_cardMatchesCriteria(oLP_Hero, criteria)) validH = false;
             if (validH) array_push(targets, oLP_Hero);
        }
        if (checkEnemy && instance_exists(oLP_Enemy)) {
             var validE = true;
             if (criteria != noone && !_cardMatchesCriteria(oLP_Enemy, criteria)) validE = false;
             if (validE) {
                 array_push(targets, oLP_Enemy);
                 // AJOUT: Inclure le bouton d'attaque directe comme cible valide (redirigé vers oLP_Enemy au clic)
                 var btn = instance_find(oAttackDirectEnemy, 0);
                 if (btn != noone) array_push(targets, btn);
             }
        }
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

/// @function hasValidTargetForEffect(card, effect, context)
/// @description Retourne true si un effet ciblé possède au moins une cible valide selon ses règles
/// @param {instance} card - La carte source (utilisée pour les restrictions d’allégeance)
/// @param {struct} effect - L’effet à vérifier
/// @param {struct} [context] - Le contexte optionnel (pour les conditions de trigger)
/// @returns {bool}
function hasValidTargetForEffect(card, effect, context = {}) {
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
                        || etype == EFFECT_PURGE
                        || etype == EFFECT_DAMAGE_TARGET
                        || etype == EFFECT_HEAL_TARGET
                       );

    // Cas non-ciblé: certains effets ont tout de même des prérequis bloquants
    if (!needsTarget) {
        // Garde spécifique: EFFECT_DESTROY doit vérifier qu'une cible existe selon critères avant d'afficher le bouton
        if (etype == EFFECT_DESTROY) {
            return isEffectActivatable(card, effect, context);
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
        // Fix pour Double Jeu (EFFECT_SUMMON + copy_target): Validation explicite pour éviter les problèmes de filtre
        if (etype == EFFECT_SUMMON && string_lower(variable_struct_exists(effect, "summon_mode") ? effect.summon_mode : "") == "copy_target") {
            var ownerFilter = variable_struct_exists(effect, "owner") ? string_lower(effect.owner) : "both";
            var criteria = variable_struct_exists(effect, "criteria") ? effect.criteria : noone;
            var foundCopy = false;
            
            // Déterminer le propriétaire de la carte source pour les comparaisons d'allégeance
            var sourceOwnerIsHero = true;
            if (instance_exists(card)) {
                if (variable_instance_exists(card, "isHeroOwner")) sourceOwnerIsHero = card.isHeroOwner;
            }
            
            with (oCardMonster) {
                if (!instance_exists(self)) continue;
                var z = variable_instance_exists(self, "zone") ? string_lower(zone) : "";
                if (z != "field" && z != "fieldselected") continue;
                
                // Vérification Allégeance
                if (ownerFilter != "both") {
                    var targetIsHero = variable_instance_exists(self, "isHeroOwner") ? self.isHeroOwner : undefined;
                    if (!is_undefined(targetIsHero)) {
                        if (ownerFilter == "ally" || ownerFilter == "hero") {
                            if (targetIsHero != sourceOwnerIsHero) continue;
                        } else if (ownerFilter == "enemy") {
                            if (targetIsHero == sourceOwnerIsHero) continue;
                        }
                    }
                }
                
                // Vérification Critères
                if (criteria != noone && script_exists(asset_get_index("_cardMatchesCriteria"))) {
                    if (!_cardMatchesCriteria(self, criteria)) continue;
                }
                
                foundCopy = true;
                break;
            }
            return foundCopy;
        }

        return isEffectActivatable(card, effect, context);
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
                if (orientation == "PV" && isFaceDown) continue;
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

/// @function isEffectActivatable(card, effect, context)
/// @description Valide de manière unifiée si un effet a des cibles/conditions satisfaites
/// @param {instance} card - La carte source (pour les restrictions d’allégeance)
/// @param {struct} effect - L’effet à vérifier
/// @param {struct} [context] - Le contexte optionnel
/// @returns {bool}
function isEffectActivatable(card, effect, context = {}) {
    if (effect == noone) return false;
    
    // 1. Vérification des conditions génériques (Once per turn, LP, Main, Phase...)
    // On utilise checkTriggerConditions si disponible pour valider les prérequis non-ciblés
    if (!is_undefined(asset_get_index("checkTriggerConditions"))) {
        // Passer le contexte complet pour valider les conditions comme summon_mode
        if (!checkTriggerConditions(card, effect, context)) return false;
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
                if (orientation == "PV" && isFaceDown) continue;
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

/// @function purgeUnit(targetUnit)
/// @description Retire tous les effets et mots-clés d'une unité (Silence)
function purgeUnit(targetUnit) {
    if (targetUnit == noone || !instance_exists(targetUnit)) return false;
    
    show_debug_message("Purge de l'unité : " + string(targetUnit.id));

    targetUnit.is_purged = true;
    
    // 1. Annuler les effets actifs dans la liste
    if (variable_instance_exists(targetUnit, "effects") && is_array(targetUnit.effects)) {
        var len = array_length(targetUnit.effects);
        for (var i = 0; i < len; i++) {
            var eff = targetUnit.effects[i];
            if (is_struct(eff)) {
                eff.negated = true;
            }
        }
    }
    
    // 2. Retirer les mots-clés (Keywords)
    if (variable_instance_exists(targetUnit, "isCamouflage")) targetUnit.isCamouflage = false;
    if (variable_instance_exists(targetUnit, "has_taunt")) targetUnit.has_taunt = false;
    if (variable_instance_exists(targetUnit, "is_stealth")) targetUnit.is_stealth = false;
    if (variable_instance_exists(targetUnit, "is_ward")) targetUnit.is_ward = false;
    if (variable_instance_exists(targetUnit, "is_lethal")) targetUnit.is_lethal = false;
    if (variable_instance_exists(targetUnit, "has_guard")) targetUnit.has_guard = false;
    if (variable_instance_exists(targetUnit, "isPercee")) targetUnit.isPercee = false;
    if (variable_instance_exists(targetUnit, "hasRepoussement")) targetUnit.hasRepoussement = false;
    if (variable_instance_exists(targetUnit, "isRepoussement")) targetUnit.isRepoussement = false;
    if (variable_instance_exists(targetUnit, "hasEgide")) targetUnit.hasEgide = false;
    if (variable_instance_exists(targetUnit, "isEgide")) targetUnit.isEgide = false;
    if (variable_instance_exists(targetUnit, "attack_damage_bonus_sources")) targetUnit.attack_damage_bonus_sources = [];
    if (variable_instance_exists(targetUnit, "hasPonction")) targetUnit.hasPonction = false;
    if (variable_instance_exists(targetUnit, "has_charge")) targetUnit.has_charge = false;
    if (variable_instance_exists(targetUnit, "isAmbidextrous")) targetUnit.isAmbidextrous = false;
    if (variable_instance_exists(targetUnit, "isPoisoner")) targetUnit.isPoisoner = false;
    
    // 3. Retirer les protections
    if (variable_instance_exists(targetUnit, "protection_sources")) targetUnit.protection_sources = [];
    if (variable_instance_exists(targetUnit, "protection_from_destroy")) targetUnit.protection_from_destroy = false;
    if (variable_instance_exists(targetUnit, "damage_reduction_sources")) targetUnit.damage_reduction_sources = [];
    if (variable_instance_exists(targetUnit, "damage_taken_bonus_sources")) targetUnit.damage_taken_bonus_sources = [];
    if (variable_instance_exists(targetUnit, "damage_reduction")) targetUnit.damage_reduction = 0;
    if (variable_instance_exists(targetUnit, "damage_taken_bonus")) targetUnit.damage_taken_bonus = 0;
    
    // 4. Retirer les buffs temporaires (Optionnel, mais logique pour un Silence complet)
    // On nettoie les contributions de buffs et les stats temporaires
    if (variable_instance_exists(targetUnit, "buff_contribs")) {
        targetUnit.buff_contribs = [];
    }
    if (variable_instance_exists(targetUnit, "temp_attack")) targetUnit.temp_attack = 0;
    if (variable_instance_exists(targetUnit, "temp_defense")) targetUnit.temp_defense = 0;
    if (variable_instance_exists(targetUnit, "tracker_flags")) targetUnit.tracker_flags = {};
    if (variable_instance_exists(targetUnit, "dot_states")) targetUnit.dot_states = [];
    if (variable_instance_exists(targetUnit, "entrave_turns_remaining")) targetUnit.entrave_turns_remaining = 0;
    if (variable_instance_exists(targetUnit, "entrave_block_attack")) targetUnit.entrave_block_attack = false;
    if (variable_instance_exists(targetUnit, "entrave_block_position")) targetUnit.entrave_block_position = false;
    if (variable_instance_exists(targetUnit, "keepCamouflageTurn")) targetUnit.keepCamouflageTurn = -1;
    
    if (variable_instance_exists(targetUnit, "original_attack") && variable_instance_exists(targetUnit, "attack")) {
        targetUnit.attack = targetUnit.original_attack;
    }
    if (variable_instance_exists(targetUnit, "original_PV") && variable_instance_exists(targetUnit, "PV")) {
        targetUnit.PV = targetUnit.original_PV;
    }
    if (variable_instance_exists(targetUnit, "max_hp") && variable_instance_exists(targetUnit, "PV")) {
        targetUnit.max_hp = targetUnit.PV;
    }
    if (variable_instance_exists(targetUnit, "current_hp") && variable_instance_exists(targetUnit, "max_hp")) {
        targetUnit.current_hp = min(targetUnit.current_hp, targetUnit.max_hp);
    }
    
    // 5. Recalculer les stats (reviendra aux stats de base)
    if (script_exists(asset_get_index("buffRecompute"))) {
        buffRecompute(targetUnit);
    }
    
    return true;
}

/// @function resetTemporaryEffects()
function resetTemporaryEffects() {
    with (oCardMonster) {
        var changed = false;
        if (variable_struct_exists(self, "temp_attack") && temp_attack != 0) { temp_attack = 0; changed = true; }
        if (variable_struct_exists(self, "temp_defense") && temp_defense != 0) { temp_defense = 0; changed = true; }
        if (changed && script_exists(asset_get_index("buffRecompute"))) {
            buffRecompute(id);
        }
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
            var d = variable_struct_exists(effect, "PV") ? effect.PV : 0;
            var parts = [];
            if (a != 0) array_push(parts, "+" + string(a) + " ATK");
            if (d != 0) array_push(parts, "+" + string(d) + " PV");
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
            
            var g1 = variable_instance_exists(self, "genre") ? string_lower(self.genre) : "";
            g1 = string_replace_all(g1, "ê", "e");
            g1 = string_replace_all(g1, "é", "e");
            g1 = string_replace_all(g1, "è", "e");
            
            var g2 = string_lower(genreWanted);
            g2 = string_replace_all(g2, "ê", "e");
            g2 = string_replace_all(g2, "é", "e");
            g2 = string_replace_all(g2, "è", "e");
            
            if (sameSide && g1 == g2) {
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

show_debug_message("### oIndicatorParent.create")

// Vérifier si on est dans la room de duel
if (room != rDuel) {
    exit;
}

if (global.isGraveyardViewerOpen) exit;

// Bloque si le tutoriel restreint les clics
if (instance_exists(oTutorielManager) && !oTutorielManager.isClickAllowed(mouse_x, mouse_y)) exit;

///////////////////////////////////////////////////////////////////////
// Attributs
///////////////////////////////////////////////////////////////////////

// Sécuriser l'accès au fieldManagerHero pour calculer la position
var fm = instance_exists(fieldManagerHero) ? fieldManagerHero : instance_find(oFieldManagerHero, 0);
if (fm == noone || !instance_exists(fm)) {
    show_debug_message("Erreur: fieldManagerHero introuvable ou détruit pour getPosLocation");
    UIManager.stopIndicator();
    return;
}
var posXY = fm.getPosLocation(type, fieldPosition);

// Vérifie si un monstre a déjà été invoqué ce tour (autoriser si invocation spéciale)
if (type == "Monster" && game.hasSummonedThisTurn[0] && UIManager.selectedSummonOrSet != "SpecialSummon") {
    show_debug_message("Tu as déjà invoqué un monstre ce tour, impossible d'en invoquer un autre.");
    UIManager.stopIndicator();
    selectManager.selected = noone; // ou garder la sélection selon besoin
    return; // Stop la création de l'indicateur et la pose
}

///////////////////////////////////////////////////////////////////////
// Méthodes
///////////////////////////////////////////////////////////////////////

// Récupère le monstre sélectionné
var selectedMonster = selectManager.selected;


var selector = instance_find(oSacrificeSelector, 0);
if (selector != noone && selector.monsterToSummon != noone) {
    // Finalise l'invocation avec la position choisie
    selector.completeSummon([posXY[0], posXY[1], fieldPosition]);
    return;
}

// Pour les monstres sans sacrifice ou les cartes magiques, invoque via le contrôleur d'actions
var payloadSummon = {
    card: selectedMonster,
    xy: [posXY[0], posXY[1], fieldPosition]
};
if (instance_exists(selectedMonster) && variable_instance_exists(selectedMonster, "instance_uid")) {
    payloadSummon.card_uid = selectedMonster.instance_uid;
}
RequestGameAction(ACTION_SUMMON, payloadSummon);
selectedMonster.fieldPosition = fieldPosition;
// Mémoriser si l'invocation est spéciale AVANT de réinitialiser l'UI
var wasSpecialSummon = (UIManager.selectedSummonOrSet == "SpecialSummon");
UIManager.stopIndicator();

if(type == "Monster") {
    selectManager.selected = noone;
    // Ne pas compter l'invocation si c'est une invocation spéciale
    if (!wasSpecialSummon) {
        game.hasSummonedThisTurn[0] = true; // Indique qu'un monstre a été invoqué ce tour
    }
    UIManager.selectedSummonOrSet = ""; // Reset après invocation
}
else {
    if (selectManager.selected != noone && instance_exists(selectManager.selected)) {
        selectManager.selected.zone = "FieldSelected";
    }
    // Post-invocation: si on venait d'un clic "Activer effet" d'un Artéfact, lancer aura puis ciblage/effet
    if (instance_exists(oSelectManager)) {
        var placed = selectManager.selected;
        var hasPending = (selectManager.pendingEffect != noone) && (selectManager.pendingEffectCard != noone) && (selectManager.pendingEffectCard == placed);
        var isArtifact = (variable_instance_exists(placed, "genre") && placed.genre == "Artéfact");
        var isDirect = (variable_instance_exists(placed, "genre") && placed.genre == "Direct");
        var isFaceDown = (variable_instance_exists(placed, "isFaceDown") && placed.isFaceDown);
        // Ne pas exécuter automatiquement l'effet si l'Artéfact est face cachée
        if (hasPending && isArtifact && !isFaceDown) {
            var eff = selectManager.pendingEffect;
            // Aura d'activation
            requestFXAura(
                placed.sprite_index,
                placed.image_index,
                placed.image_xscale,
                placed.image_yscale,
                placed.image_angle,
                600,
                18,
                10,
                1.50,
                0.80,
                placed.x,
                placed.y
            );
            
            // Phase 1.5: Command Pattern
            var idx = selectManager.pendingEffectIndex;
            if (idx != -1 && variable_instance_exists(placed, "instance_uid")) {
                RequestGameAction(ACTION_ACTIVATE_EFFECT, {
                    source_uid: placed.instance_uid,
                    effect_index: idx
                });
                // On suppose que l'action va réussir et consommer/marquer l'effet
            } else {
                // Fallback
                markEffectAsUsed(placed, eff);
                executeEffect(placed, eff, {});
            }
            
            // Nettoyage de l'état différé
            selectManager.pendingEffect = noone;
            selectManager.pendingEffectCard = noone;
            selectManager.pendingEffectIndex = -1;
        }
        // Si l'effet est différé et la carte est posée face cachée, afficher le bouton Effet tout de suite
        if (hasPending && isArtifact && isFaceDown) {
            if (instance_exists(oUIManager)) {
                UIManager.displayEffectButton(placed);
            }
            // On conserve pendingEffect pour que le clic puisse enchaîner après retournement
        }
        // Si l'effet est différé pour un sort Direct, exécuter immédiatement après la pose
        if (hasPending && isDirect) {
            var effd = selectManager.pendingEffect;
            // Aura d'activation
            requestFXAura(
                placed.sprite_index,
                placed.image_index,
                placed.image_xscale,
                placed.image_yscale,
                placed.image_angle,
                600,
                18,
                10,
                1.50,
                0.80,
                placed.x,
                placed.y
            );
            
            // Phase 1.5: Command Pattern
            var idxD = selectManager.pendingEffectIndex;
            if (idxD != -1 && variable_instance_exists(placed, "instance_uid")) {
                RequestGameAction(ACTION_ACTIVATE_EFFECT, {
                    source_uid: placed.instance_uid,
                    effect_index: idxD
                });
                // On laisse le contrôleur gérer la consommation/marquage
            } else {
                // Fallback
                var resolved = executeEffect(placed, effd, {});
                if (resolved) {
                    // Marquer l'effet comme utilisé et consommer le sort Direct immédiatement
                    if (!is_undefined(markEffectAsUsed)) { markEffectAsUsed(placed, effd); }
                    if (!is_undefined(consumeSpellIfNeeded)) { consumeSpellIfNeeded(placed, effd); }
                }
            }
            
            // Nettoyage de l'état différé
            selectManager.pendingEffect = noone;
            selectManager.pendingEffectCard = noone;
            selectManager.pendingEffectIndex = -1;
        }
        // Si un effet d'Artéfact a été différé et que la carte vient d'être posée face visible
        if (selectManager.pendingEffect != noone && placed != noone && isArtifact && !isFaceDown) {
            var __placed_card = placed;
            var __effect = selectManager.pendingEffect;
            // Exécuter l'effet (déjà marqué comme utilisé au clic du bouton)
            // Phase 1.5: Command Pattern
            var idxP = selectManager.pendingEffectIndex;
            if (idxP != -1 && variable_instance_exists(__placed_card, "instance_uid")) {
                RequestGameAction(ACTION_ACTIVATE_EFFECT, {
                    source_uid: __placed_card.instance_uid,
                    effect_index: idxP
                });
            } else {
                executeEffect(__placed_card, __effect, {});
            }
            selectManager.pendingEffect = noone;
            selectManager.pendingEffectCard = noone;
            selectManager.pendingEffectIndex = -1;
        }
    }
}

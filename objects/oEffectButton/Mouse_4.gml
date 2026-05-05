/// @description Effect Button Click

// Enregistrer le clic UI pour bloquer la sélection de carte sous-jacente
global.last_ui_click_time = current_time;

if (global.isGraveyardViewerOpen) exit;
// Bloque l'interaction si le sélecteur de sacrifice est ouvert
if (variable_global_exists("isSacrificeSelectorOpen") && global.isSacrificeSelectorOpen) exit;

// Vérifier que la carte parent existe
if (!variable_instance_exists(self, "parentCard") || parentCard == "" || !instance_exists(parentCard)) {
    show_debug_message("### oEffectButton: aucune carte parente valide");
    exit;
}

var card = parentCard;
var isInHand = (variable_instance_exists(card, "zone") && (card.zone == "Hand" || card.zone == "HandSelected"));
var isMagicInHand = (variable_instance_exists(card, "type") && card.type == "Magic" && isInHand);

// Récupérer l'effet activable après un éventuel retournement
var effect = getAvailableEffect(card);
var effectIndex = -1;
if (effect != noone && script_exists(asset_get_index("getEffectIndex"))) {
    effectIndex = getEffectIndex(card, effect);
}

// Contexte de tour/phase
var isHeroTurn = false;
if (instance_exists(game)) {
    if (variable_instance_exists(game, "local_player_index")) {
        isHeroTurn = (game.player_current == game.local_player_index);
    } else {
        isHeroTurn = (game.player_current == 0);
    }
}
var currentPhase = (instance_exists(game) && variable_instance_exists(game, "phase")) ? game.phase[game.phase_current] : "";
var isQuick = (effect != noone && variable_struct_exists(effect, "trigger") && effect.trigger == TRIGGER_QUICK_EFFECT);
// Détection d'un effet continu (permet d'afficher un bouton même sans effet manuel)
var hasContinuous = false;
if (variable_instance_exists(card, "effects")) {
    for (var ci = 0; ci < array_length(card.effects); ci++) {
        var ce = card.effects[ci];
        if (is_struct(ce) && variable_struct_exists(ce, "trigger") && ce.trigger == TRIGGER_CONTINUOUS) { hasContinuous = true; break; }
    }
}
if (variable_instance_exists(card, "genre")) {
    var gl = string_lower(card.genre);
    if (gl == "continu" || gl == "continue" || gl == "terrain") { hasContinuous = true; }
}

// Si aucun effet manuel, autoriser le flux pour les cartes à effet continu (pose/retournement)
// ET pour les cartes Magie en main (mode Sort/Direct) qui sont toujours jouables
if (effect == noone && !hasContinuous && !isMagicInHand) {
    show_debug_message("### oEffectButton: aucun effet disponible");
    UIManager.hideEffectButton();
    exit;
}
// Bloquer l'activation hors tour du héros, mais autoriser les magies continues en main à toutes phases
var allowAnyPhaseForContinuousInHand = (hasContinuous && (variable_instance_exists(card, "zone") && (card.zone == "Hand" || card.zone == "HandSelected")));
if (!(isQuick || (isHeroTurn && (currentPhase == "Summon" || currentPhase == "Main" || allowAnyPhaseForContinuousInHand)))) {
    show_debug_message("### oEffectButton: activation refusée hors tour/phase (" + string(currentPhase) + ")");
    UIManager.hideEffectButton();
    exit;
}
// Vérification runtime: ne pas activer si aucune cible/cout valide (s'applique uniquement aux effets manuels)
if (effect != noone && !hasValidTargetForEffect(card, effect)) {
    show_debug_message("### oEffectButton: aucune cible/cout valide -> annulation");
    UIManager.hideEffectButton();
    exit;
}

var isArtifact = (variable_instance_exists(card, "genre") && card.genre == "Artéfact");
// Artéfact check removed

// === NOUVEAU: Jouer la carte Magie directement (Mode HS) ===
// Remplace l'ancienne logique oSummon pour les sorts
// NOTE: Tout est joué en direct pour l'instant (demande utilisateur), les effets seront adaptés plus tard.
if (isMagicInHand) {
    show_debug_message("### oEffectButton: Jouer Magie depuis la main (HS Style)");
    
    // --- FIX: Empêcher le clic si Secret déjà actif ou limite atteinte ---
    var isSecretCheck = (variable_instance_exists(card, "genre") && string_lower(card.genre) == "secret");
    if (isSecretCheck && variable_global_exists("activeSecretsHero") && ds_exists(global.activeSecretsHero, ds_type_list)) {
        // 1. Check Max 5
        if (ds_list_size(global.activeSecretsHero) >= 5) {
            show_debug_message("### oEffectButton: Activation annulée (Max 5 secrets atteints)");
            UIManager.hideEffectButton();
            exit;
        }
        // 2. Check Doublon
        for (var i = 0; i < ds_list_size(global.activeSecretsHero); i++) {
            var existing = ds_list_find_value(global.activeSecretsHero, i);
            if (instance_exists(existing) && variable_instance_exists(existing, "name") && existing.name == card.name) {
                show_debug_message("### oEffectButton: Activation annulée (Secret déjà actif)");
                UIManager.hideEffectButton();
                exit;
            }
        }
    }

    // --- MANA CHECK (Préventif UI) ---
    var cost = variable_instance_exists(card, "mana_cost") ? card.mana_cost : (variable_instance_exists(card, "star") ? card.star : 0);
    var currentMana = variable_global_exists("mana_hero") ? global.mana_hero : 0;
    
    if (currentMana < cost) {
        show_debug_message("### oEffectButton: Mana insuffisant (" + string(currentMana) + "/" + string(cost) + ") -> Annulation");
        UIManager.hideEffectButton();
        exit;
    }

    // --- LOGIQUE SLOT POUR CONTINUS/ARTEFACTS ---
    var targetSlot = -1;
    var targetXY = [0, 0];
    var needsFieldSlot = (hasContinuous || isArtifact);
    
    if (needsFieldSlot) {
        show_debug_message("### oEffectButton: Carte Continue/Artéfact -> Recherche de slot MagicTrap");
        var ownerIsHero = (variable_instance_exists(card, "isHeroOwner") && card.isHeroOwner);
        var fieldMgr = ownerIsHero ? fieldManagerHero : fieldManagerEnemy;
        var mtField = fieldMgr.getField("MagicTrap");
        var hasFreeMTSlot = false;
        
        if (mtField != noone && variable_struct_exists(mtField, "cards")) {
            for (var mti = 0; mti < array_length(mtField.cards); mti++) {
                if (mtField.cards[mti] == 0) { 
                    targetSlot = mti;
                    hasFreeMTSlot = true; 
                    break; 
                }
            }
        }
        
        if (!hasFreeMTSlot) {
            show_debug_message("### oEffectButton: aucun slot MagicTrap libre -> activation refusée");
            UIManager.hideEffectButton();
            exit;
        }
        
        // Calculer les coordonnées écran du slot
        if (fieldMgr != noone) {
            targetXY = fieldMgr.getPosLocation("Magic", targetSlot);
        }
    }

    // NOTE: Le ciblage manuel est géré par sEffects.executeEffect lors de l'appel à ACTION_SUMMON.
    // On ne doit pas intercepter ici pour éviter de briser le flux (callback sur l'effet et non la carte).
    show_debug_message("### oEffectButton: Délégation du ciblage à executeEffect via ACTION_SUMMON");

    var playMode = "Summon";
    if (isSecretCheck) {
        playMode = "Set";
    }
    
    var playXY = [0, 0, -1];
    if (needsFieldSlot) {
        playXY = [targetXY[0], targetXY[1], targetSlot];
    }

    var payload = {
        card: card,
        xy: playXY,
        summon_mode: playMode
    };
    if (variable_instance_exists(card, "instance_uid")) {
        payload.card_uid = card.instance_uid;
    }
    RequestGameAction(ACTION_SUMMON, payload);
    
    // Nettoyage UI
    UIManager.selectedSummonOrSet = "";
    if (instance_exists(oSelectManager)) {
        // Ne pas désélectionner si un ciblage d'effet est en cours (lancé par l'action)
        if (!oSelectManager.targetingEffect) {
            with(oSelectManager) { unSelectAll(); }
        }
    }
    UIManager.hideSummonAndSet();
    UIManager.hideEffectButton();
    exit;
}

// Si carte face cachée sur le terrain: lancer l'animation de flip après validations
var isFaceDown = (variable_instance_exists(card, "isFaceDown") && card.isFaceDown);
var isOnField = (variable_instance_exists(card, "zone") && (card.zone == "Field" || card.zone == "FieldSelected"));
if (isFaceDown && isOnField) {
    // Démarrer l'animation de retournement; le Step de oCardParent mettra image_index=0 et isFaceDown=false
    card.position_anim_active = true;
    card.anim_flip_speed = (variable_global_exists("ANIM_FLIP_SPEED") ? global.ANIM_FLIP_SPEED : 0.03);
    card.anim_flip_orig_scale = card.image_xscale;
    card.anim_phase = "flip_in";
}

// Suppression logique de placement différé (Artéfact/Continu) - Tout passe par le mode Direct (HS Style)
// Le code ci-dessous est désactivé/supprimé car toutes les magies sont jouées directement via isMagicInHand

// Demande de halo doré (file d’attente, un par un)
requestFXAura(
    card.sprite_index,
    card.image_index,
    card.image_xscale,
    card.image_yscale,
    card.image_angle,
    600,   // durée ~0.6s
    18,    // padding
    10,    // épaisseur
    1.50,  // scale multiplier
    0.80,  // alpha start
    card.x,
    card.y
);

// Pour les cartes déjà sur le terrain (y compris Artéfacts), exécuter l'effet manuel s'il existe
var effectResolved = false;
if (effect != noone) {
    // Phase 1.5: Command Pattern
    if (effectIndex != -1 && variable_instance_exists(card, "instance_uid")) {
        RequestGameAction(ACTION_ACTIVATE_EFFECT, {
            source_uid: card.instance_uid,
            effect_index: effectIndex
        });
        // Note: effectResolved n'est plus pertinent ici car l'action est asynchrone/centralisée.
        // On suppose que l'action s'exécutera.
        effectResolved = true; // Pour déclencher le nettoyage UI ci-dessous si besoin
    } else {
        // Fallback
        effectResolved = executeEffect(card, effect, {});
        if (effectResolved) {
            markEffectAsUsed(card, effect);
        }
    }
}

// Consommer les sorts Direct (non-continus) après la résolution
// Note: Avec le Command Pattern, la consommation est gérée dans le contrôleur.
// On garde ceci pour le fallback ou si l'action est locale immédiate.
if (!is_undefined(consumeSpellIfNeeded) && effectResolved && (effectIndex == -1)) {
    consumeSpellIfNeeded(card, effect);
}

// Nettoyer l'UI
UIManager.hideSummonAndSet();
UIManager.hideEffectButton();

// oHeroPower - Create Event
isHeroOwner = true;
powerData = {};
hasUsedThisTurn = false;
hover = false;
hoverTimer = 0;
HOVER_THRESHOLD = 60; // 60 frames = 1 second at 60fps

// Visuals
radius = 24;
icon_scale = 0.5;
color_ready = c_aqua;
color_used = c_gray;
color_no_mana = c_red;

// Initialisation via struct
init = function(_isHeroOwner, _powerData) {
    isHeroOwner = _isHeroOwner;
    powerData = _powerData;
    hasUsedThisTurn = false;
    
    // Positionnement automatique
    if (isHeroOwner) {
        if (instance_exists(oLP_Hero)) {
            var inst = instance_find(oLP_Hero, 0);
            // Placer à droite du LP Hero
            x = inst.x + 140; 
            y = inst.y - 150;
        } else {
            x = 330; 
            y = 992;
        }
    } else {
        if (instance_exists(oLP_Enemy)) {
            var inst = instance_find(oLP_Enemy, 0);
            // Placer à gauche du LP Enemy
            x = inst.x - 140;
            y = inst.y + 150;
        } else {
            x = 1590; 
            y = 96;
        }
    }
};

// Vérification disponibilité
canActivate = function() {
    if (hasUsedThisTurn) return false;
    
    // Vérifier le tour
    if (instance_exists(oGame)) {
        if (oGame.player_current == 0 && !isHeroOwner) return false; // Tour du joueur, mais pouvoir ennemi
        if (oGame.player_current == 1 && isHeroOwner) return false; // Tour ennemi, mais pouvoir joueur
    }
    
    // Vérifier le mana
    var currentMana = isHeroOwner ? global.mana_hero : global.mana_enemy;
    var cost = variable_struct_exists(powerData, "mana_cost") ? powerData.mana_cost : 2;
    
    if (currentMana < cost) return false;
    
    // Vérifier conditions spécifiques (ex: besoin de cible ou board non plein)
    var pid = variable_struct_exists(powerData, "id") ? powerData.id : "";
    
    if (pid == "appel_profondeurs") {
        // Besoin de place sur le board ?
        var field = isHeroOwner ? fieldManagerHero.getField("Monster") : fieldManagerEnemy.getField("Monster");
        var hasSpace = false;
        for (var i = 0; i < array_length(field.cards); i++) {
            if (field.cards[i] == 0) { hasSpace = true; break; }
        }
        if (!hasSpace) return false;
    }
    
    // rage_pierre removed

    if (pid == "protection_divine") {
        // Besoin d'un serviteur ennemi à cibler
        if (isHeroOwner) {
            if (!has_any_monster_on_field_enemy()) return false;
        } else {
            if (!has_any_monster_on_field_hero()) return false;
        }
    }
    
    // Lancer de Hache ne nécessite pas de vérification complexe car il y a toujours au moins un Héros adverse
    
    return true;
};

// Callback de sélection de cible (pour Lancer de Hache)
applyLancerHache = function(target) {
    if (target == noone || !instance_exists(target)) return;
    
    // Vérifier si c'est une cible valide (Monstre ou Héros/LP)
    // Note: On accepte tout ce qui a des PV
    var isValid = false;
    var isMonster = (target.object_index == oCardMonster || object_is_ancestor(target.object_index, oCardMonster));
    var isLP = (object_get_name(target.object_index) == "oLP_Hero" || object_get_name(target.object_index) == "oLP_Enemy");
    
    if (isMonster || isLP) {
        // Animation physique (Epee -> Blessure)
        if (variable_global_exists("animEffectRequestProjectileTarget")) {
            animEffectRequestProjectileTarget("physique", id, target, 1);
        }

        // Appliquer dégâts (1)
        if (isMonster) {
            // Utiliser le système de dégâts standard si possible, sinon direct
            if (variable_instance_exists(target, "takeDamage")) {
                target.takeDamage(1);
            } else {
                target.current_hp -= 1;
                // Animation dégât (si dispo)
                if (variable_instance_exists(target, "visual_damage")) target.visual_damage(1);
            }
        } else if (isLP) {
             // Dégâts au héros
              if (variable_instance_exists(target, "nbLP")) {
                 target.nbLP -= 1;
                 // Animation dégât (si dispo)
                  if (variable_instance_exists(target, "visual_damage")) {
                      // target.visual_damage(1); // Hypothétique
                  }
              } else if (variable_instance_exists(target, "hp")) {
                  target.hp -= 1;
              }
         }
        
        // Consume Mana
        var cost = variable_struct_exists(powerData, "mana_cost") ? powerData.mana_cost : 2;
        
        if (isHeroOwner) global.mana_hero -= cost;
        else global.mana_enemy -= cost;
        
        hasUsedThisTurn = true;
        show_debug_message("### Lancer de Hache applied on " + string(variable_instance_exists(target, "name") ? target.name : "Hero"));
    } else {
        show_debug_message("### Invalid target for Lancer de Hache");
    }
};

// Callback de sélection de cible (pour Protection Divine)
applyProtectionDivine = function(target) {
    if (target == noone || !instance_exists(target)) return;
    
    // Check if target is valid (Enemy Monster)
    var targetIsEnemy = (target.isHeroOwner != isHeroOwner);
    var isMonster = (target.object_index == oCardMonster || object_is_ancestor(target.object_index, oCardMonster));
    
    if (targetIsEnemy && isMonster) {
        // Apply effect
        target.attack -= 1;
        if (target.attack < 0) target.attack = 0;
        
        // Consume Mana
        var cost = variable_struct_exists(powerData, "mana_cost") ? powerData.mana_cost : 2;
        
        if (isHeroOwner) global.mana_hero -= cost;
        else global.mana_enemy -= cost;
        
        hasUsedThisTurn = true;
        show_debug_message("### Protection Divine applied on " + string(target.name));
    } else {
        show_debug_message("### Invalid target for Protection Divine");
    }
};

onTargetSelected = function(target) {
    if (powerData.id == "protection_divine") {
        applyProtectionDivine(target);
    } else if (powerData.id == "lancer_hache") {
        applyLancerHache(target);
    }
    
    // End targeting
    if (instance_exists(oSelectManager)) {
        oSelectManager.targetingEffect = false;
        oSelectManager.targetingEffectId = noone;
        with(oTargetingArrow) instance_destroy();
        // Restore UI
        if (variable_instance_exists(UIManager, "hideSummonAndSet")) UIManager.hideSummonAndSet(); 
    }
};

// Exécution
activate = function(target) {
    if (is_undefined(target)) target = noone;
    if (!canActivate()) return;
    
    // Cas spécial: Ciblage requis
    if (powerData.id == "protection_divine" || powerData.id == "lancer_hache") {
         if (target != noone) {
             if (powerData.id == "protection_divine") applyProtectionDivine(target);
             if (powerData.id == "lancer_hache") applyLancerHache(target);
         } else if (instance_exists(oSelectManager)) {
            oSelectManager.startTargeting(id);
            oSelectManager.createTargetingArrow(id);
            if (variable_instance_exists(UIManager, "hideSummonAndSet")) UIManager.hideSummonAndSet();
            if (variable_instance_exists(UIManager, "hideEffectButton")) UIManager.hideEffectButton();
        }
        return; // On arrête ici, le mana sera consommé dans onTargetSelected ou applyProtectionDivine
    }

    var cost = variable_struct_exists(powerData, "mana_cost") ? powerData.mana_cost : 2;
    
    // Consommer Mana
    if (isHeroOwner) {
        global.mana_hero -= cost;
    } else {
        global.mana_enemy -= cost;
    }
    
    hasUsedThisTurn = true;
    show_debug_message("### Activation Pouvoir Héroïque: " + powerData.name);
    
    // Effet spécifique
    switch (powerData.id) {
        case "appel_profondeurs":
            var fieldMgr = isHeroOwner ? fieldManagerHero : fieldManagerEnemy;
            var field = fieldMgr.getField("Monster");
            var freeSlots = [];
            for (var i = 0; i < array_length(field.cards); i++) {
                if (field.cards[i] == 0) array_push(freeSlots, i);
            }
            
            if (array_length(freeSlots) > 0) {
                var randIndex = irandom(array_length(freeSlots) - 1);
                var pos = freeSlots[randIndex];
                var XY = fieldMgr.getPosLocation("Monster", pos);
                var X = XY[0];
                var Y = XY[1];
                
                var inst = instance_create_layer(X, Y, "Instances", oCoureurAbyssien);
                if (inst != noone) {
                    inst.isToken = true;
                    inst.isHeroOwner = isHeroOwner;
                    inst.is_player_card = isHeroOwner;
                    inst.face_down = false;
                    inst.zone = "Field";
                    inst.fieldPosition = pos; 
                    inst.depth = 0;
                    inst.orientation = "Attack";
                    inst.visible = false; 
                    inst.attacksUsedThisTurn = 99; // Mal d'invocation
                    
                    // Assign to field array
                    field.cards[pos] = inst;
                    
                    // Trigger Summon Effects
                    var ctx = { summon_mode: "SpecialSummon", owner_is_hero: isHeroOwner };
                    registerTriggerEvent(TRIGGER_ON_SUMMON, inst, ctx);
                    registerTriggerEvent(TRIGGER_ON_MONSTER_SUMMON, inst, ctx);

                    // Animation Speciale Standard
                    var fx = instance_create_layer(220, room_height/2, "UI", FX_Invocation);
                    if (fx != noone) {
                        fx.spriteGhost = inst.sprite_index;
                        fx.imageGhost = 0;
                        fx.target_x = X;
                        fx.target_y = Y;
                        fx.card_real = inst;
                        fx.owner_is_hero = isHeroOwner;
                        fx.col_main = make_color_rgb(255, 215, 0); // Or (Standard Special Summon)
                        fx.summon_mode = "SpecialSummon";
                        fx.field_position = pos;
                        fx.card_type = "Monster";
                        fx.image_angle = isHeroOwner ? 0 : 180;
                    }
                    
                    // fieldMgr.rearrange(false);
                }
            }
            break;
            
        case "pillage":
            // Pillage : Copie une carte de la main adverse et l'ajoute à sa main. Elle coute (1) de moins
            var targetHand = noone;
            var myHand = noone;
            
            // Trouver les mains (Instances de oHand)
            // isHeroOwner = true -> C'est le Joueur. Target = Enemy Hand, My = Hero Hand
            // isHeroOwner = false -> C'est le Bot. Target = Hero Hand, My = Enemy Hand
            
            with (oHand) {
                if (isHeroOwner == other.isHeroOwner) {
                    myHand = id;
                } else {
                    targetHand = id;
                }
            }
            
            if (instance_exists(targetHand) && instance_exists(myHand)) {
                var enemyCards = targetHand.cards;
                var validIndices = [];
                for(var i=0; i<array_length(enemyCards); i++) {
                    if (enemyCards[i] != 0) array_push(validIndices, i);
                }
                
                if (array_length(validIndices) > 0) {
                    var rndIndex = validIndices[irandom(array_length(validIndices)-1)];
                    var cardToCopy = enemyCards[rndIndex];
                    
                    if (is_struct(cardToCopy) || instance_exists(cardToCopy)) {
                        // Création de la copie
                        var cardObj = noone;
                        if (is_struct(cardToCopy)) {
                            // Si c'est une struct (IA view of Player hand, usually empty/backs if hidden, but data might be there)
                            if (variable_struct_exists(cardToCopy, "object_index")) cardObj = cardToCopy.object_index;
                        } else {
                            // Instance (Player view of AI hand - if revealed? Or AI view of Player hand?)
                            cardObj = cardToCopy.object_index;
                        }
                        
                        // Fallback si on ne peut pas copier (ex: carte cachée sans info)
                        // Pour le bot (James), il triche un peu, il voit les cartes de oHandHero qui sont des instances réelles.
                        
                        if (cardObj != noone) {
                            var newCard = instance_create_layer(0, 0, "Instances", cardObj);
                            newCard.isHeroOwner = isHeroOwner;
                            newCard.face_down = false; // Révélé pour le voleur
                            newCard.mana_cost = max(0, newCard.mana_cost - 1);
                            newCard.original_mana_cost = newCard.mana_cost; // Fix pour éviter recalcul
                            
                            // Ajout à la main
                            myHand.addCard(newCard);
                            
                            // Feedback visuel
                             var fx = instance_create_layer(x, y, "UI", FX_Invocation); // Ou autre FX
                             if (fx != noone) {
                                 fx.spriteGhost = newCard.sprite_index;
                                 fx.target_x = isHeroOwner ? 600 : 600; // Centre
                                 fx.target_y = isHeroOwner ? 900 : 100;
                             }
                        }
                    }
                }
            }
            break;

        // dague_sournoise removed


            
        default:
            show_debug_message("### Pouvoir Héroïque inconnu ou non implémenté: " + powerData.id);
            break;
    }
};

// Helpers pour vérifier le board (similaires aux scripts globaux mais scope local si besoin)
has_any_monster_on_field_hero = function() {
    var found = false;
    with (oCardMonster) { if (isHeroOwner && zone == "Field") { found = true; break; } }
    return found;
};

has_any_monster_on_field_enemy = function() {
    var found = false;
    with (oCardMonster) { if (!isHeroOwner && zone == "Field") { found = true; break; } }
    return found;
};
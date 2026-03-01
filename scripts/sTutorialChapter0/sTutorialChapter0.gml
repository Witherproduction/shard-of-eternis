/// @function Tutorial_Chapter0_Init()
/// @description Initialise le tutoriel du Chapitre 0 (Tour 1)
function Tutorial_Chapter0_Init() {
    if (variable_instance_exists(id, "tuto_turn1_done")) return;
    
    tuto_turn1_done = true;
    
    // Set Enemy HP to 3 for tutorial purposes
    var LP_Enemy_Instance = instance_find(oLP_Enemy, 0);
    if (LP_Enemy_Instance != noone) {
        LP_Enemy_Instance.nbLP = 3;
    }
    
    var tuto = instance_create_layer(0, 0, "UI", oTutorielManager);
    tuto.tutorial_id = 1; // ID pour le Tour 1
    
    // Configuration des étapes du Tour 1
    var steps = [
        {
            text: "Bienvenue Archonte, nous allons voir ensemble comment se déroule un duel.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Voici vos points de vie (LP). Si ils tombent à 0, vous perdez le duel.",
            highlight: [20, 900, 350, 180],
            arrow: [192, 900, 270]
        },
        {
            text: "Voici votre Main. C'est ici que se trouvent vos cartes à jouer.",
            highlight: [380, 940, 1160, 170],
            arrow: [960, 940, 270]
        },
        {
            text: "Voici votre Deck. Vous piochez une carte au début de chaque tour.",
            highlight: [1470, 870, 130, 185],
            arrow: [1536, 870, 270]
        },
        {
            text: "Pour jouer des cartes, vous avez besoin de Mana. Votre Mana augmente de 1 à chaque tour et se recharge complètement au début de votre tour.",
            highlight: [1635, 847, 150, 150], // Highlight zone mana (estimé près du deck)
            arrow: [1710, 827, 270]
        },
        {
            text: "A vous de jouer ! Cliquez sur la carte 'Araignée Forestière' pour la sélectionner.",
            highlight: [0,0,0,0], // Sera mis à jour dynamiquement
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Le bouton 'Invoquer' (Summon) permet de placer le monstre sur le terrain. Notez son coût en Mana.",
            highlight: noone, // Sera mis à jour dynamiquement
            arrow: noone,
            allow_clicks: false
        },
        {
            text: "Cliquez sur le bouton 'Invoquer' pour continuer.",
            highlight: noone, // Sera mis à jour dynamiquement
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Choisissez un emplacement libre. Les monstres peuvent être placés sur la Ligne de Front ou de Retraite.\nLa Ligne de Front protège votre Héros et votre Ligne de Retraite.",
            highlight: noone, // Sera mis à jour dynamiquement
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Voici l'indicateur de Phase et de Tour.\nLe tour est divisé en 3 phases :\n1. Start: Pioche et Mana.\n2. Main: Jouer des cartes et Attaquer.\n3. End: Fin du tour.",
            highlight: [1605, 380, 250, 270],
            arrow: [1590, 515, 0]
        },
        {
            text: "Cliquez sur ce bouton pour passer à la phase de Fin (End).",
            highlight: noone, // Sera mis à jour dynamiquement
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Durant le premier tour où ils sont invoqués, les monstres ne peuvent pas attaquer (Mal d'invocation).\nCliquez à nouveau pour terminer votre tour.",
            highlight: noone, // Sera mis à jour dynamiquement
            arrow: noone,
            hide_next_button: true
        }
    ];
    
    tuto.setSteps(steps);
}

/// @function Tutorial_Chapter0_Update()
/// @description Gère la logique frame-par-frame du tutoriel Chapitre 0
/// @return {boolean} True si le tutoriel est actif et doit bloquer le reste du jeu
function Tutorial_Chapter0_Update() {
    // 1. Pause si le tutoriel est affiché
    if (instance_exists(oTutorielManager)) {
        var tuto = instance_find(oTutorielManager, 0);
        
        // Vérifier si c'est bien le tutoriel du Tour 1
        if (!variable_instance_exists(tuto, "tutorial_id") || tuto.tutorial_id != 1) return false;
        
        // Safety: If turn > 1, force destroy tutorial 1 to avoid blocking AI
        if (variable_instance_exists(oGame, "nbTurn") && oGame.nbTurn > 1) {
             show_debug_message("### TUTO SAFETY: Destroying persistent Tutorial 1 in Turn " + string(oGame.nbTurn));
             instance_destroy(tuto);
             return false;
        }

        var step_idx = tuto.current_step;
        
        // Calcul des coordonnées GUI relatives à la caméra
        var cam_x = camera_get_view_x(view_camera[0]);
        var cam_y = camera_get_view_y(view_camera[0]);
        
        // Etape 5: Sélection Araignée (Interactive)
        if (step_idx == 5) {
             // 1. Vérifier si une carte valide est DÉJÀ sélectionnée (n'importe quelle Araignée)
             if (instance_exists(oSelectManager) && oSelectManager.selected != noone) {
                 var sel = oSelectManager.selected;
                 // Vérification de sécurité sur l'instance
                 if (instance_exists(sel)) {
                     var isNameValid = (sel.object_index == oAraigneeForestiere);
                     if (!isNameValid && variable_instance_exists(sel, "name")) {
                         isNameValid = (string_lower(sel.name) == "araignée forestière");
                     }
                     
                     var isHand = (variable_instance_exists(sel, "zone") && (sel.zone == "Hand" || sel.zone == "HandSelected"));
                     var isOwner = (variable_instance_exists(sel, "isHeroOwner") && sel.isHeroOwner);
                     
                     if (isNameValid && isHand && isOwner) {
                         show_debug_message("### TUTO: Valid spider selected, forcing next step");
                         tuto.forceNextStep();
                         return true; // Sortir pour éviter de redessiner le highlight inutilement
                     }
                 }
             }

             // 2. Sinon, trouver une araignée à mettre en évidence (la première trouvée)
             var spider_to_highlight = noone;
             with(oCardParent) { 
                 var match = (object_index == oAraigneeForestiere);
                 if (!match && variable_instance_exists(id, "name")) {
                     match = (string_lower(name) == "araignée forestière");
                 }
                 
                 if (variable_instance_exists(id, "isHeroOwner") && isHeroOwner && 
                     match && 
                     zone == "Hand") {
                     spider_to_highlight = id;
                     break; // S'arrêter à la première pour stabiliser le highlight
                 }
             }
             
             if (spider_to_highlight != noone) {
                 var w = sprite_get_width(spider_to_highlight.sprite_index) * spider_to_highlight.image_xscale;
                 var h = sprite_get_height(spider_to_highlight.sprite_index) * spider_to_highlight.image_yscale;
                 var xx = spider_to_highlight.x - cam_x - w/2;
                 var yy = spider_to_highlight.y - cam_y - h/2;
                 tuto.updateHighlight(xx, yy, w, h);
             } else {
                  // Debug si aucune araignée n'est trouvée
                  if (current_time % 60 == 0) show_debug_message("### TUTO: No spider found to highlight!");
             }
        }
        // Etape 6 (Explique Summon) ou 7 (Clic Summon)
        else if (step_idx == 6 || step_idx == 7) {
             var target = noone;
             if (instance_exists(oSummon)) target = instance_find(oSummon, 0);
             
             if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 // Highlight
                 var margin = 10;
                 tuto.updateHighlight(xx - margin, yy - margin, w + margin*2, h + margin*2);
                 
                 // Arrow
                 var cx = xx + w/2;
                 var cy = yy; 
                 tuto.updateArrows([[cx, cy - 10, 270]]);
             }
             
             // Interaction (Step 7 only)
             if (step_idx == 7) {
                 if (instance_exists(oUIManager) && oUIManager.selectedSummonOrSet == "Summon") {
                     show_debug_message("### TUTO: Summon clicked, forcing next step");
                     tuto.forceNextStep();
                 }
             }
        }
        // Etape 8: Clic Terrain (Interactive)
        else if (step_idx == 8) {
             // Highlight Field Zones (oIndicatorParent)
             var min_x = 99999, min_y = 99999, max_x = -99999, max_y = -99999;
             var found = false;
             
             with(oIndicatorParent) {
                 if (sprite_index != -1) {
                     found = true;
                     var w = sprite_get_width(sprite_index) * image_xscale;
                     var h = sprite_get_height(sprite_index) * image_yscale;
                     var ox = sprite_get_xoffset(sprite_index) * image_xscale;
                     var oy = sprite_get_yoffset(sprite_index) * image_yscale;
                     var xx = x - cam_x - ox; 
                     var yy = y - cam_y - oy;
                     
                     if (xx < min_x) min_x = xx;
                     if (yy < min_y) min_y = yy;
                     if (xx + w > max_x) max_x = xx + w;
                     if (yy + h > max_y) max_y = yy + h;
                 }
             }
             
             if (found) {
                      var margin = 5;
                      tuto.updateHighlight(min_x - margin, min_y - margin, (max_x - min_x) + margin*2, (max_y - min_y) + margin*2);
                      tuto.updateArrows([[min_x + (max_x - min_x)/2, min_y - 20, 270]]);
                  }
             
             // Check if spider is on field
             var onField = false;
             with(oCardParent) { 
                 if (variable_instance_exists(id, "name") && string_lower(name) == "araignée forestière" && zone == "Field") {
                     onField = true; 
                 }
             }
             if (onField) {
                 show_debug_message("### TUTO: Spider on field, forcing next step");
                 tuto.forceNextStep();
             }
        }
        // Etape 10 & 11: Next Phase Button
        else if (step_idx == 10 || step_idx == 11) {
             var target = noone;
             if (instance_exists(oNextStep)) target = instance_find(oNextStep, 0);
             
             if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 // Highlight
                 var margin = 10;
                 tuto.updateHighlight(xx - margin, yy - margin, w + margin*2, h + margin*2);
                 
                 // Arrow
                 var cx = xx + w/2;
                 var cy = yy; 
                 tuto.updateArrows([[cx, cy - 10, 270]]);
             }
             
             if (step_idx == 10) {
                 // Wait for Attack phase
                 if (variable_instance_exists(oGame, "phase") && oGame.phase[oGame.phase_current] == "Attack") {
                      tuto.forceNextStep();
                 }
             }
             else if (step_idx == 11) {
                 // Wait for End of Turn (Player changes to Enemy)
                 if (variable_instance_exists(oGame, "player") && oGame.player[oGame.player_current] == "Enemy") {
                      tuto.forceNextStep();
                 }
             }
        }

        if (variable_instance_exists(oGame, "nbTurn") && oGame.nbTurn > 1) {
             show_debug_message("### WARNING: Tutorial_Chapter0_Update BLOCKING during Turn " + string(oGame.nbTurn));
        }
        return true; // Arrêter toute logique de jeu (timers, etc.)
    }
    return false;
}

/// @function Tutorial_Turn3_Init()
/// @description Initialise le tutoriel du Chapitre 0 (Tour 3 - Tour du Joueur)
function Tutorial_Turn3_Init() {
    if (variable_instance_exists(id, "tuto_turn3_done")) return;
    
    tuto_turn3_done = true;
    show_debug_message("### TUTO TURN 3: Init started");

    // FIX: Donner 10 mana pour permettre de jouer Secret (2) + Gobelin (2) (Updated for higher costs)
    global.mana_hero = 10;
    // Ajuster le max aussi pour éviter confusion visuelle
    global.mana_max_hero = 10;
    
    var tuto = instance_create_layer(0, 0, "UI", oTutorielManager);
    tuto.tutorial_id = 3; // ID pour le Tour 3
    
    // Calcul de la position du bouton de phase (oNextStep)
    var btnPhase = instance_find(oNextStep, 0);
    var h_phase = noone;
    var cam_x = camera_get_view_x(view_camera[0]);
    var cam_y = camera_get_view_y(view_camera[0]);
    
    if (btnPhase != noone) {
        var w = sprite_get_width(btnPhase.sprite_index) * btnPhase.image_xscale;
        var h = sprite_get_height(btnPhase.sprite_index) * btnPhase.image_yscale;
        var xx = btnPhase.x - cam_x;
        var yy = btnPhase.y - cam_y;
        h_phase = [xx, yy, w, h];
    }
    
    // Calcul de la position des Araignées pour le highlight
    var h_spider_hero = noone;
    var h_spider_enemy = noone;
    
    var countSpider = instance_number(oAraigneeForestiere);
    for (var i = 0; i < countSpider; i++) {
        var spider = instance_find(oAraigneeForestiere, i);
        if (variable_instance_exists(spider, "isHeroOwner")) {
            var bx = spider.bbox_left - cam_x;
            var by = spider.bbox_top - cam_y;
            var bw = spider.bbox_right - spider.bbox_left;
            var bh = spider.bbox_bottom - spider.bbox_top;
            
            if (spider.isHeroOwner) {
                h_spider_hero = [bx, by, bw, bh];
            } else {
                h_spider_enemy = [bx, by, bw, bh];
            }
        }
    }

    // Configuration des étapes du Tour 3
    var steps = [
        {
            text: "C'est à votre tour ! Exceptionnellement, vous disposez de 10 Mana pour apprendre les règles.\nAu début de chaque tour, vous piochez automatiquement une carte.",
            highlight: noone, 
            arrow: noone
        },
        {
            text: "Vous avez pioché une nouvelle carte !\nParlons des cartes Magie. Il en existe 2 types principaux :",
            highlight: noone,
            arrow: noone
        },
        {
            text: "- Sort : Effet immédiat.\n- Secret : Se déclenche automatiquement sous condition (généralement pendant le tour adverse).",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Tant que vous avez assez de Mana, vous pouvez jouer autant de cartes que vous voulez par tour.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Sélectionnez la carte 'Feuillage Protecteur' (Secret) dans votre main.",
            highlight: noone, // Sera mis à jour dynamiquement (Carte en main)
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Cliquez sur le bouton 'Activer' pour préparer le Secret.",
            highlight: noone, // Sera mis à jour dynamiquement (oEffectButton)
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Bien ! Maintenant, invoquez le 'Gobelin Furtif' en position d'Attaque.",
            highlight: noone, // Sera mis à jour dynamiquement (Carte en main)
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Ce monstre possède la capacité 'Camouflage'.\nIl ne peut pas être attaqué ou ciblé tant qu'il est camouflé.",
            highlight: noone, // Sera mis à jour dynamiquement (Gobelin sur terrain)
            arrow: noone
        },
        {
            text: "Sélectionnez votre 'Araignée Forestière'.",
            highlight: h_spider_hero, 
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Cliquez sur le bouton d'attaque (épée) qui apparaît.",
            highlight: noone, // Sera mis à jour dynamiquement (oAttack)
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Ciblez l'Araignée Forestière adverse.",
            highlight: h_spider_enemy, 
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Lorsque deux monstres combattent, ils s'infligent des dégâts égaux à leur ATK.\nSi les dégâts reçus sont supérieurs aux PV, le monstre est détruit.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Notez que votre Secret ne s'est pas activé. C'est normal : les Secrets ne s'activent que durant le tour de l'adversaire.",
            highlight: noone, // Feuillage on field
            arrow: noone
        },
        {
            text: "Votre tour est terminé. Cliquez à nouveau sur le bouton de phase pour passer au tour de l'adversaire.",
            highlight: h_phase,
            arrow: noone,
            hide_next_button: true
        }
    ];
    
    tuto.setSteps(steps);
}

/// @function Tutorial_Turn3_Update()
/// @description Gère la logique frame-par-frame du tutoriel Chapitre 0 (Tour 3)
/// @return {boolean} True si le tutoriel est actif et doit bloquer le reste du jeu
function Tutorial_Turn3_Update() {
    // 1. Pause si le tutoriel est affiché
    if (instance_exists(oTutorielManager)) {
        var tuto = instance_find(oTutorielManager, 0);
        
        // Vérifier si c'est bien le tutoriel du Tour 3
        if (!variable_instance_exists(tuto, "tutorial_id") || tuto.tutorial_id != 3) return false;
        
        var step_idx = tuto.current_step;
        
        // Calcul des coordonnées GUI relatives à la caméra
        var cam_x = camera_get_view_x(view_camera[0]);
        var cam_y = camera_get_view_y(view_camera[0]);
        
        // Etape 0: Attendre fin de pioche
        if (step_idx == 0) {
             // Wait for phase change (Pick -> Main)
             if (variable_instance_exists(oGame, "phase") && oGame.phase[oGame.phase_current] != "Pick") {
                  //tuto.forceNextStep(); // Non, on laisse le joueur cliquer sur Suivant
             }
        }
        // Etape 4: Sélectionner Feuillage Protecteur
        else if (step_idx == 4) {
             var isSelected = false;
             // Vérifier si la carte est sélectionnée
             if (instance_exists(oSelectManager) && oSelectManager.selected != noone) {
                 var sel = oSelectManager.selected;
                 if (instance_exists(sel) && 
                    (sel.object_index == oFeuillageProtecteur || (variable_instance_exists(sel, "name") && string_pos("Feuillage", sel.name) > 0)) && 
                    sel.isHeroOwner) {
                     isSelected = true;
                 }
             }
             
             // Vérification supplémentaire suggérée par l'utilisateur (hand.selected / zone HandSelected)
             if (!isSelected) {
                 with(oCardParent) {
                     if ((object_index == oFeuillageProtecteur || (variable_instance_exists(id, "name") && string_pos("Feuillage", name) > 0)) && 
                         isHeroOwner && zone == "HandSelected") {
                         isSelected = true;
                         break;
                     }
                 }
             }

             if (isSelected) {
                 show_debug_message("### TUTO TURN 3: Feuillage selected, next step");
                 tuto.forceNextStep();
             } else {
                 var card_target = noone;
                 // Chercher Feuillage dans la main
                 with(oCardParent) {
                     if ((object_index == oFeuillageProtecteur || (variable_instance_exists(id, "name") && string_pos("Feuillage", name) > 0)) && 
                         zone == "Hand" && isHeroOwner) {
                         card_target = id;
                         break;
                     }
                 }
                 
                 if (card_target != noone) {
                     var w = sprite_get_width(card_target.sprite_index) * card_target.image_xscale;
                     var h = sprite_get_height(card_target.sprite_index) * card_target.image_yscale;
                     var xx = card_target.x - cam_x - w/2;
                     var yy = card_target.y - cam_y - h/2;
                     tuto.updateHighlight(xx, yy, w, h);
                     tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
                 }
             }
        }
        // Etape 5: Cliquer sur le bouton Activer (oEffectButton) et Vérifier si joué
        else if (step_idx == 5) {
             var target = noone;
             if (instance_exists(oEffectButton)) target = instance_find(oEffectButton, 0);
             
             if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 // Highlight
                 var margin = 10;
                 tuto.updateHighlight(xx - margin, yy - margin, w + margin*2, h + margin*2);
                 tuto.updateArrows([[xx + w/2, yy - 10, 270]]);
             }
             
             // Vérifier si le mode placement est actif (bouton cliqué) OU si la carte est sur le terrain (Auto-play)
             var cardOnField = false;
             with(oCardParent) {
                 if ((object_index == oFeuillageProtecteur || (variable_instance_exists(id, "name") && string_pos("Feuillage", name) > 0)) && 
                     (zone == "Field" || zone == "Secret") && isHeroOwner) {
                     cardOnField = true;
                     break;
                 }
             }

             if (instance_exists(oIndicatorParent) || cardOnField) {
                 tuto.forceNextStep();
             }
        }

        // Etape 6: Invoquer Gobelin Furtif (Index recalé suite suppression étape placement)
        else if (step_idx == 6) {
             var isSelected = false;
             var isSummonMode = false;
             
             // Vérifier si le Gobelin est sélectionné
             if (instance_exists(oSelectManager) && oSelectManager.selected != noone) {
                 var sel = oSelectManager.selected;
                 if (instance_exists(sel) && 
                    (sel.object_index == oGobelinFurtif || (variable_instance_exists(sel, "name") && string_pos("Gobelin", sel.name) > 0)) && 
                    sel.isHeroOwner) {
                     isSelected = true;
                 }
             }
             
             // Vérifier si le mode Invocation est actif
             if (instance_exists(oUIManager) && oUIManager.selectedSummonOrSet == "Summon") {
                 isSummonMode = true;
             }

             if (isSummonMode) {
                 // Highlight Field Zones (oIndicatorParent)
                 var min_x = 99999, min_y = 99999, max_x = -99999, max_y = -99999;
                 var found = false;
                 
                 with(oIndicatorParent) {
                     if (sprite_index != -1) {
                         found = true;
                         var w = sprite_get_width(sprite_index) * image_xscale;
                         var h = sprite_get_height(sprite_index) * image_yscale;
                         var ox = sprite_get_xoffset(sprite_index) * image_xscale;
                         var oy = sprite_get_yoffset(sprite_index) * image_yscale;
                         var xx = x - cam_x - ox; 
                         var yy = y - cam_y - oy;
                         
                         if (xx < min_x) min_x = xx;
                         if (yy < min_y) min_y = yy;
                         if (xx + w > max_x) max_x = xx + w;
                         if (yy + h > max_y) max_y = yy + h;
                     }
                 }
                 
                 if (found) {
                     var margin = 5;
                     tuto.updateHighlight(min_x - margin, min_y - margin, (max_x - min_x) + margin*2, (max_y - min_y) + margin*2);
                     tuto.updateArrows([[min_x + (max_x - min_x)/2, min_y - 20, 270]]);
                 }
             } 
             else if (isSelected) {
                 // Highlight bouton Summon
                 var target = noone;
                 if (instance_exists(oSummon)) target = instance_find(oSummon, 0);
                 
                 if (target != noone) {
                     var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                     var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                     var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                     var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                     var xx = target.x - cam_x - ox;
                     var yy = target.y - cam_y - oy;
                     
                     // Highlight
                     var margin = 10;
                     tuto.updateHighlight(xx - margin, yy - margin, w + margin*2, h + margin*2);
                     tuto.updateArrows([[xx + w/2, yy - 10, 270]]);
                 }
             } 
             else {
                 var card_target = noone;
                 // Chercher Gobelin dans la main
                 with(oCardParent) {
                     if ((object_index == oGobelinFurtif || (variable_instance_exists(id, "name") && string_pos("Gobelin", name) > 0)) && 
                         zone == "Hand" && isHeroOwner) {
                         card_target = id;
                         break;
                     }
                 }
                 
                 if (card_target != noone) {
                     var w = sprite_get_width(card_target.sprite_index) * card_target.image_xscale;
                     var h = sprite_get_height(card_target.sprite_index) * card_target.image_yscale;
                     var xx = card_target.x - cam_x - w/2;
                     var yy = card_target.y - cam_y - h/2;
                     tuto.updateHighlight(xx, yy, w, h);
                     tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
                 }
             }
             
             // Vérifier si invoqué (sur le terrain)
             var played = false;
             with(oCardParent) {
                 if ((object_index == oGobelinFurtif || (variable_instance_exists(id, "name") && string_pos("Gobelin", name) > 0)) && 
                     zone == "Field" && isHeroOwner) {
                     played = true;
                     break;
                 }
             }
             if (played) {
                 show_debug_message("### TUTO TURN 3: Gobelin summoned!");
                 tuto.forceNextStep();
             }
        }
        // Etape 7: Expliquer Camouflage
        else if (step_idx == 7) {
             var target = noone;
             // Chercher Gobelin sur le terrain
             with(oCardParent) {
                 if ((object_index == oGobelinFurtif || (variable_instance_exists(id, "name") && string_pos("Gobelin", name) > 0)) && 
                     zone == "Field" && isHeroOwner) {
                     target = id;
                     break;
                 }
             }
             
             if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx - 10, yy - 10, w + 20, h + 20);
                 tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
             }
        }
        
        // Etape 8: Selectionner Araignee (Index recalé: était 9)
        else if (step_idx == 8) {
             var attacker = noone;
             with(oAraigneeForestiere) {
                 if (isHeroOwner && (zone == "Field" || zone == "FieldSelected")) attacker = id;
             }
             
             if (attacker != noone) {
                 if (instance_exists(oSelectManager) && oSelectManager.selected == attacker) {
                     tuto.forceNextStep();
                 }
             }
        }
        
        // Etape 9: Cliquer Attack (Index recalé: était 10)
        else if (step_idx == 9) {
             var btn = instance_find(oAttack, 0);
             if (btn != noone) {
                 var bx = btn.bbox_left - cam_x;
                 var by = btn.bbox_top - cam_y;
                 var bw = btn.bbox_right - btn.bbox_left;
                 var bh = btn.bbox_bottom - btn.bbox_top;
                 
                 tuto.updateHighlight(bx, by, bw, bh);
                 tuto.updateArrows([[bx + bw/2, by - 20, 270]]);
             }
             
             if (instance_exists(oSelectManager) && oSelectManager.attackMode) {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 10: Cibler Ennemi (Index recalé: était 11)
        else if (step_idx == 10) {
             var enemyAlive = false;
             with(oAraigneeForestiere) {
                 if (!isHeroOwner && (zone == "Field" || zone == "FieldSelected")) {
                     enemyAlive = true;
                 }
             }
             
             // Si plus d'araignée ennemie en vie (détruite ou au cimetière)
             if (!enemyAlive) {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 12: Secret Highlight (Icone à côté des PV)
        else if (step_idx == 12) {
             var lp = instance_find(oLP_Hero, 0);
             if (lp != noone) {
                 // L'icône est dessinée à (x, y-70) avec un scale de 0.5
                 var secret_x = lp.x;
                 var secret_y = lp.y - 70;
                 
                 var spr = asset_get_index("sSecret");
                 var w = 60; 
                 var h = 60;
                 
                 if (spr != -1) {
                     w = sprite_get_width(spr) * 0.5;
                     h = sprite_get_height(spr) * 0.5;
                 }
                 
                 // Centrer le highlight sur l'icône
                 var xx = secret_x - w/2 - cam_x;
                 var yy = secret_y - h/2 - cam_y;
                 
                 // Ajustement fin pour bien encadrer
                 var margin = 5;
                 tuto.updateHighlight(xx - margin, yy - margin, w + margin*2, h + margin*2);
                 tuto.updateArrows([[xx + w/2 + margin, yy - 20, 270]]);
             }
        }
        // Etape 13: Fin de tour (Index recalé: était 14)
        else if (step_idx == 13) {
             var target = noone;
             if (instance_exists(oNextStep)) target = instance_find(oNextStep, 0);
             
             if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 // Highlight
                 var margin = 10;
                 tuto.updateHighlight(xx - margin, yy - margin, w + margin*2, h + margin*2);
                 tuto.updateArrows([[xx + w/2, yy - 10, 270]]);
             }
             
             // Attendre le changement de tour (Le joueur clique, le tour passe à l'ennemi)
             if (variable_instance_exists(oGame, "player") && oGame.player[oGame.player_current] == "Enemy") {
                 tuto.forceNextStep(); // Fin du tuto Tour 3
             }
        }

        return true; // Bloquer le reste du jeu
    }
    return false;
}

/// @function Tutorial_Turn5_Init()
/// @description Initialise le tutoriel du Chapitre 0 (Tour 5 - Tour du Joueur)
function Tutorial_Turn5_Init() {
    if (variable_instance_exists(id, "tuto_turn5_done")) return;
    
    tuto_turn5_done = true;
    show_debug_message("### TUTO TURN 5: Init started");
    
    var tuto = instance_create_layer(0, 0, "UI", oTutorielManager);
    tuto.tutorial_id = 5; // ID pour le Tour 5
    
    var steps = [
        {
            text: "C'est à votre tour ! La pioche est automatique.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Le Maître des Passes a un effet 'Crépuscule'. Cela signifie qu'il s'active automatiquement à la fin de votre tour.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "À l'inverse, un effet 'Aube' s'activerait au début du tour.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Sélectionnez le Maître des Passes dans votre main.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Cliquez sur le bouton 'Invoquer' (Summon).",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Placez le monstre sur le terrain.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        // Etape supprimée (Phase d'attaque obsolète)
        {
            text: "Votre Gobelin Furtif est prêt à combattre.\nSélectionnez-le.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Cliquez sur le bouton d'attaque (épée).",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Attaquez la Tortue Vagabonde en défense.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "La Tortue a perdu des PV mais n'est pas détruite car ses PV sont supérieurs à votre ATK.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Terminez votre tour pour observer l'effet Crépuscule du Maître des Passes.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        }
    ];
    
    tuto.setSteps(steps);
}

/// @function Tutorial_Turn5_Update()
/// @description Gère la logique frame-par-frame du tutoriel Chapitre 0 (Tour 5)
/// @return {boolean} True si le tutoriel est actif et doit bloquer le reste du jeu
function Tutorial_Turn5_Update() {
    if (instance_exists(oTutorielManager)) {
        var tuto = instance_find(oTutorielManager, 0);
        if (!variable_instance_exists(tuto, "tutorial_id") || tuto.tutorial_id != 5) return false;
        
        var step_idx = tuto.current_step;
        var cam_x = camera_get_view_x(view_camera[0]);
        var cam_y = camera_get_view_y(view_camera[0]);
        
        // Etape 0: Attendre fin de pioche
        if (step_idx == 0) {
             // Wait for phase change (Pick -> Main)
             if (variable_instance_exists(oGame, "phase") && oGame.phase[oGame.phase_current] != "Pick") {
                  //tuto.forceNextStep(); // Non, on laisse le joueur cliquer sur Suivant
             }
        }
        
        // Etape 3: Sélectionner Maître des Passes
        else if (step_idx == 3) {
             var target = noone;
             var isSelected = false;
             
             with(oCardParent) {
                 if (object_index == oMaitrePasse && (zone == "Hand" || zone == "HandSelected") && isHeroOwner) {
                     target = id;
                     if (zone == "HandSelected") isSelected = true;
                     break;
                 }
             }
             
             if (instance_exists(oSelectManager) && oSelectManager.selected == target) {
                 isSelected = true;
             }
             
             if (isSelected) {
                 tuto.forceNextStep();
             } else if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx, yy, w, h);
                 tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
             }
        }
        
        // Etape 4: Cliquer sur Summon
        else if (step_idx == 4) {
             var target = noone;
             if (instance_exists(oSummon)) target = instance_find(oSummon, 0);
             
             if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 // Highlight
                 var margin = 10;
                 tuto.updateHighlight(xx - margin, yy - margin, w + margin*2, h + margin*2);
                 tuto.updateArrows([[xx + w/2, yy - 10, 270]]);
             }
             
             if (instance_exists(oUIManager) && oUIManager.selectedSummonOrSet == "Summon") {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 5: Placer sur le terrain
        else if (step_idx == 5) {
             // Highlight Field Zones (oIndicatorParent)
             var min_x = 99999, min_y = 99999, max_x = -99999, max_y = -99999;
             var found = false;
             
             with(oIndicatorParent) {
                 if (sprite_index != -1) {
                     found = true;
                     var w = sprite_get_width(sprite_index) * image_xscale;
                     var h = sprite_get_height(sprite_index) * image_yscale;
                     var ox = sprite_get_xoffset(sprite_index) * image_xscale;
                     var oy = sprite_get_yoffset(sprite_index) * image_yscale;
                     var xx = x - cam_x - ox; 
                     var yy = y - cam_y - oy;
                     
                     if (xx < min_x) min_x = xx;
                     if (yy < min_y) min_y = yy;
                     if (xx + w > max_x) max_x = xx + w;
                     if (yy + h > max_y) max_y = yy + h;
                 }
             }
             
             if (found) {
                  var margin = 5;
                  tuto.updateHighlight(min_x - margin, min_y - margin, (max_x - min_x) + margin*2, (max_y - min_y) + margin*2);
                  tuto.updateArrows([[min_x + (max_x - min_x)/2, min_y - 20, 270]]);
             }

             var target = noone;
             with(oCardParent) {
                 if (object_index == oMaitrePasse && isHeroOwner && zone == "Field") {
                     target = id;
                     break;
                 }
             }
             
             if (target != noone) {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 6: Passer en Phase Attaque (SUPPRIMÉ)
        /*
        else if (step_idx == 6) {
             var btn = instance_find(oNextStep, 0);
             
             if (btn != noone) {
                 var w = sprite_get_width(btn.sprite_index) * btn.image_xscale;
                 var h = sprite_get_height(btn.sprite_index) * btn.image_yscale;
                 var ox = sprite_get_xoffset(btn.sprite_index) * btn.image_xscale;
                 var oy = sprite_get_yoffset(btn.sprite_index) * btn.image_yscale;
                 var xx = btn.x - cam_x - ox;
                 var yy = btn.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx, yy, w, h);
                 tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
             }
             
             if (variable_instance_exists(oGame, "phase") && oGame.phase[oGame.phase_current] == "Attack") {
                 tuto.forceNextStep();
             }
        }
        */
        
        // Etape 7: Sélectionner Gobelin Furtif (Index recalé: devient 6)
        else if (step_idx == 6) {
             var target = noone;
             var isSelected = false;
             
             with(oCardParent) {
                 if (object_index == oGobelinFurtif && (zone == "Field" || zone == "FieldSelected") && isHeroOwner) {
                     target = id;
                     if (zone == "FieldSelected") isSelected = true;
                     break;
                 }
             }
             
             if (target != noone) {
                 if (instance_exists(oSelectManager) && oSelectManager.selected == target) {
                     isSelected = true;
                 }
                 
                 if (isSelected) {
                     tuto.forceNextStep();
                 } else {
                     var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                     var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                     var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                     var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                     var xx = target.x - cam_x - ox;
                     var yy = target.y - cam_y - oy;
                     
                     tuto.updateHighlight(xx, yy, w, h);
                     tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
                 }
             }
        }
        
        // Etape 7: Cliquer sur Attaquer (Index recalé: devient 7)
        else if (step_idx == 7) {
             var btn = instance_find(oAttack, 0);
             if (btn != noone) {
                 var bx = btn.bbox_left - cam_x;
                 var by = btn.bbox_top - cam_y;
                 var bw = btn.bbox_right - btn.bbox_left;
                 var bh = btn.bbox_bottom - btn.bbox_top;
                 tuto.updateHighlight(bx, by, bw, bh);
                 tuto.updateArrows([[bx + bw/2, by - 20, 270]]);
             }
             
             if (instance_exists(oSelectManager) && oSelectManager.attackMode) {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 8: Attaquer Tortue Vagabonde (Index recalé: devient 8)
        else if (step_idx == 8) {
             var target = noone;
             with(oCardParent) {
                 if (object_index == oTortueVagabonde && !isHeroOwner && zone == "Field") {
                     target = id;
                     break;
                 }
             }
             
             var gobelin = noone;
             with(oCardParent) {
                 if (object_index == oGobelinFurtif && isHeroOwner) {
                     gobelin = id;
                     break;
                 }
             }
             
             // Detection de l'attaque via attacksUsedThisTurn (hasAttacked n'existe pas)
             if (gobelin != noone && variable_instance_exists(gobelin, "attacksUsedThisTurn") && gobelin.attacksUsedThisTurn > 0) {
                 tuto.forceNextStep();
             }
             else if (target != noone) {
                 var xx = target.bbox_left - cam_x;
                 var yy = target.bbox_top - cam_y;
                 var w = target.bbox_right - target.bbox_left;
                 var h = target.bbox_bottom - target.bbox_top;
                 
                 tuto.updateHighlight(xx, yy, w, h);
                 tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
             }
        }
        
        // Etape 10: Fin de tour (Index recalé: devient 10)
        else if (step_idx == 10) {
             var btn = instance_find(oNextStep, 0);
             if (btn != noone) {
                 var w = sprite_get_width(btn.sprite_index) * btn.image_xscale;
                 var h = sprite_get_height(btn.sprite_index) * btn.image_yscale;
                 var ox = sprite_get_xoffset(btn.sprite_index) * btn.image_xscale;
                 var oy = sprite_get_yoffset(btn.sprite_index) * btn.image_yscale;
                 var xx = btn.x - cam_x - ox;
                 var yy = btn.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx, yy, w, h);
                 tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
             }
             
             if (variable_instance_exists(oGame, "player") && oGame.player[oGame.player_current] == "Enemy") {
                 tuto.forceNextStep();
             }
        }
        
        return true;
    }
    return false;
}

/// @function Tutorial_Turn7_Init()
/// @description Initialise le tutoriel du Chapitre 0 (Tour 7 - Tour du Joueur)
function Tutorial_Turn7_Init() {
    if (variable_instance_exists(id, "tuto_turn7_done")) return;
    
    tuto_turn7_done = true;
    show_debug_message("### TUTO TURN 7: Init started");
    
    var tuto = instance_create_layer(0, 0, "UI", oTutorielManager);
    tuto.tutorial_id = 7; // Configuration des étapes du Tour 7
    var steps = [
        {
            text: "C'est le tour 7 ! La pioche est automatique.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Certaines cartes possèdent des effets 'Eveil' ou 'Brisé'.\nUn effet 'Eveil' s'active dès que la carte entre en jeu.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Un effet 'Brisé', quant à lui, s'active lorsque la carte est détruite et envoyée au cimetière.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Le Peau-de-Roc Robuste possède 'Charge' (attaque immédiate) et 'Percée' (ignore la Ligne de Front).\nSélectionnez-le.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Cliquez sur le bouton 'Invoquer'.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Placez le monstre sur le terrain.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Grâce à son effet 'Charge', il est prêt à attaquer immédiatement !",
            highlight: noone,
            arrow: noone
        },
        // Etape supprimée (Phase d'attaque obsolète)
        {
            text: "Sélectionnez votre Peau-de-Roc Robuste.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Cliquez sur le bouton d'attaque.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Attaquez la Tortue Vagabonde.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Terminez votre tour.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        }
    ];
    
    tuto.setSteps(steps);
}

/// @function Tutorial_Turn7_Update()
/// @description Gère la logique frame-par-frame du tutoriel Chapitre 0 (Tour 7)
/// @return {boolean} True si le tutoriel est actif et doit bloquer le reste du jeu
function Tutorial_Turn7_Update() {
    if (instance_exists(oTutorielManager)) {
        var tuto = instance_find(oTutorielManager, 0);
        if (!variable_instance_exists(tuto, "tutorial_id") || tuto.tutorial_id != 7) return false;
        
        var step_idx = tuto.current_step;
        var cam_x = camera_get_view_x(view_camera[0]);
        var cam_y = camera_get_view_y(view_camera[0]);
        
        // Etape 0: Attendre fin de pioche
        if (step_idx == 0) {
             // Wait for phase change (Pick -> Main)
             if (variable_instance_exists(oGame, "phase") && oGame.phase[oGame.phase_current] != "Pick") {
                  //tuto.forceNextStep(); // Non, on laisse le joueur cliquer sur Suivant
             }
        }
        
        // Etape 3: Sélectionner Peau-de-Roc Robuste
        else if (step_idx == 3) {
             var target = noone;
             var isSelected = false;
             
             with(oCardParent) {
                 if (object_index == oPeauRocRobuste && (zone == "Hand" || zone == "HandSelected") && isHeroOwner) {
                     target = id;
                     if (zone == "HandSelected") isSelected = true;
                     break;
                 }
             }
             
             if (instance_exists(oSelectManager) && oSelectManager.selected == target) {
                 isSelected = true;
             }
             
             if (isSelected) {
                 tuto.forceNextStep();
             } else if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx, yy, w, h);
                 tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
             }
        }
        
        // Etape 4: Cliquer sur Invoquer
        else if (step_idx == 4) {
             var target = noone;
             if (instance_exists(oSummon)) target = instance_find(oSummon, 0);
             
             if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 var margin = 10;
                 tuto.updateHighlight(xx - margin, yy - margin, w + margin*2, h + margin*2);
                 tuto.updateArrows([[xx + w/2, yy - 10, 270]]);
             }
             
             if (instance_exists(oUIManager) && oUIManager.selectedSummonOrSet == "Summon") {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 5: Placer sur le terrain
        else if (step_idx == 5) {
             // Highlight Field Zones
             var min_x = 99999, min_y = 99999, max_x = -99999, max_y = -99999;
             var found = false;
             
             with(oIndicatorParent) {
                 if (sprite_index != -1) {
                     found = true;
                     var w = sprite_get_width(sprite_index) * image_xscale;
                     var h = sprite_get_height(sprite_index) * image_yscale;
                     var ox = sprite_get_xoffset(sprite_index) * image_xscale;
                     var oy = sprite_get_yoffset(sprite_index) * image_yscale;
                     var xx = x - cam_x - ox; 
                     var yy = y - cam_y - oy;
                     
                     if (xx < min_x) min_x = xx;
                     if (yy < min_y) min_y = yy;
                     if (xx + w > max_x) max_x = xx + w;
                     if (yy + h > max_y) max_y = yy + h;
                 }
             }
             
             if (found) {
                  var margin = 5;
                  tuto.updateHighlight(min_x - margin, min_y - margin, (max_x - min_x) + margin*2, (max_y - min_y) + margin*2);
                  tuto.updateArrows([[min_x + (max_x - min_x)/2, min_y - 20, 270]]);
             }

             var target = noone;
             with(oCardParent) {
                 if (object_index == oPeauRocRobuste && isHeroOwner && zone == "Field") {
                     target = id;
                     break;
                 }
             }
             
             if (target != noone) {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 6: Montrer l'ATK boostée
        else if (step_idx == 6) {
             var target = noone;
             with(oCardParent) {
                 if (object_index == oPeauRocRobuste && isHeroOwner && zone == "Field") {
                     target = id;
                     break;
                 }
             }
             
             if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx, yy, w, h);
                 tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
             }
        }
        
        // (Ancienne étape 7 supprimée - Phase Attaque)
        
        // Etape 7: Sélectionner Peau-de-Roc Robuste (Index recalé: devient 7)
        else if (step_idx == 7) {
             var target = noone;
             var isSelected = false;
             
             with(oCardParent) {
                 if (object_index == oPeauRocRobuste && (zone == "Field" || zone == "FieldSelected") && isHeroOwner) {
                     target = id;
                     if (zone == "FieldSelected") isSelected = true;
                     break;
                 }
             }
             
             if (target != noone) {
                 if (instance_exists(oSelectManager) && oSelectManager.selected == target) {
                     isSelected = true;
                 }
                 
                 if (isSelected) {
                     tuto.forceNextStep();
                 } else {
                     var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                     var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                     var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                     var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                     var xx = target.x - cam_x - ox;
                     var yy = target.y - cam_y - oy;
                     
                     tuto.updateHighlight(xx, yy, w, h);
                     tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
                 }
             }
        }
        
        // Etape 8: Cliquer sur Attaquer (Index recalé: devient 8)
        else if (step_idx == 8) {
             var btn = instance_find(oAttack, 0);
             if (btn != noone) {
                 var bx = btn.bbox_left - cam_x;
                 var by = btn.bbox_top - cam_y;
                 var bw = btn.bbox_right - btn.bbox_left;
                 var bh = btn.bbox_bottom - btn.bbox_top;
                 tuto.updateHighlight(bx, by, bw, bh);
                 tuto.updateArrows([[bx + bw/2, by - 20, 270]]);
             }
             
             if (instance_exists(oSelectManager) && oSelectManager.attackMode) {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 9: Attaquer Tortue Vagabonde (Index recalé: devient 9)
        else if (step_idx == 9) {
             // Init tracking variables
             if (!variable_instance_exists(tuto, "turn7_step10_init")) {
                 tuto.turn7_step10_init = true;
                 
                 tuto.tortue_exists_start = false;
                 with(oCardParent) {
                     if (object_index == oTortueVagabonde && !isHeroOwner && zone == "Field") {
                         tuto.tortue_exists_start = true;
                         break;
                     }
                 }
             }

             // Check triggers
             var trigger_next = false;
             
             // Target destroyed (disappeared from field)
             var target_still_exists = false;
             var target_ref = noone;
             with(oCardParent) {
                 if (object_index == oTortueVagabonde && !isHeroOwner && zone == "Field") {
                     target_still_exists = true;
                     target_ref = id;
                     break;
                 }
             }
             
             if (tuto.tortue_exists_start && !target_still_exists) {
                 trigger_next = true;
             }
             
             if (trigger_next) {
                 tuto.forceNextStep();
             }
             else if (target_ref != noone) {
                 var xx = target_ref.bbox_left - cam_x;
                 var yy = target_ref.bbox_top - cam_y;
                 var w = target_ref.bbox_right - target_ref.bbox_left;
                 var h = target_ref.bbox_bottom - target_ref.bbox_top;
                 
                 tuto.updateHighlight(xx, yy, w, h);
                 tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
             }
        }
        
        // Etape 10: Fin de tour (Index recalé: devient 10)
        else if (step_idx == 10) {
             var btn = instance_find(oNextStep, 0);
             if (btn != noone) {
                 var w = sprite_get_width(btn.sprite_index) * btn.image_xscale;
                 var h = sprite_get_height(btn.sprite_index) * btn.image_yscale;
                 var ox = sprite_get_xoffset(btn.sprite_index) * btn.image_xscale;
                 var oy = sprite_get_yoffset(btn.sprite_index) * btn.image_yscale;
                 var xx = btn.x - cam_x - ox;
                 var yy = btn.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx, yy, w, h);
                 tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
             }
             
             if (variable_instance_exists(oGame, "player") && oGame.player[oGame.player_current] == "Enemy") {
                 tuto.forceNextStep();
             }
        }
        
        return true;
    }
    return false;
}

/// @function Tutorial_Turn9_Init()
/// @description Initialise le tutoriel du Chapitre 0 (Tour 9 - Tour du Joueur)
function Tutorial_Turn9_Init() {
    if (variable_instance_exists(id, "tuto_turn9_done")) return;
    
    tuto_turn9_done = true;
    
    // Set Enemy HP to 3 for tutorial purposes
    var LP_Enemy_Instance = instance_find(oLP_Enemy, 0);
    if (LP_Enemy_Instance != noone) {
        LP_Enemy_Instance.nbLP = 3;
    }

    show_debug_message("### TUTO TURN 9: Init started");
    
    var tuto = instance_create_layer(0, 0, "UI", oTutorielManager);
    tuto.tutorial_id = 9; // ID pour le Tour 9
    
    var steps = [
        {
            text: "C'est le tour 9 ! La pioche est automatique.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Votre secret 'Feuillage Protecteur' s'est activé durant le tour adverse !\nLe Gobelin Furtif a été attaqué, ce qui a déclenché le piège.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Voici l'Envahisseur Gueule-Roche.\n'Eveil' : Effet immédiat à l'invocation.\n'Brisé' : Effet déclenché à la destruction.",
            highlight: noone,
            arrow: noone,
            hide_next_button: false
        },
        {
            text: "Invoquez l'Envahisseur Gueule-Roche maintenant.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Cliquez sur le bouton 'Invoquer' (Summon).",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Choisissez un emplacement libre sur votre Ligne de Front pour invoquer le monstre.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Vos créatures sont prêtes à attaquer.",
            highlight: noone,
            arrow: noone,
            hide_next_button: false
        },
        {
            text: "Sélectionnez votre Peau-de-Roc Robuste sur le terrain.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Cliquez sur le bouton 'Attaquer'.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Si l'Araignée est sur la Ligne de Front, détruisez-la avec le Peau-de-Roc. Sinon, attaquez directement.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Sélectionnez votre Gobelin Furtif.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Cliquez sur le bouton 'Attaquer'.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Attaquez directement l'adversaire avec le Gobelin.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Sélectionnez votre Envahisseur Gueule-Roche.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Cliquez sur le bouton 'Attaquer'.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Attaquez directement pour finir le duel !",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Félicitations Archonte, vous êtes enfin prêt. Nous allons vous envoyer sur Eternis ! Bonne chance !",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Cliquez sur le bouton 'Valider' de l'écran de fin de duel.",
            highlight: noone,
            arrow: noone,
            hide_next_button: false
        }
    ];
    
    tuto.setSteps(steps);
}

/// @function Tutorial_Turn9_Update()
/// @description Gère la logique frame-par-frame du tutoriel Chapitre 0 (Tour 9)
/// @return {boolean} True si le tutoriel est actif et doit bloquer le reste du jeu
function Tutorial_Turn9_Update() {
    if (instance_exists(oTutorielManager)) {
        var tuto = instance_find(oTutorielManager, 0);
        if (!variable_instance_exists(tuto, "tutorial_id") || tuto.tutorial_id != 9) return false;
        
        var step_idx = tuto.current_step;
        var cam_x = camera_get_view_x(view_camera[0]);
        var cam_y = camera_get_view_y(view_camera[0]);
        
        // Etape 0: Attendre fin de pioche
        if (step_idx == 0) {
             if (variable_instance_exists(oGame, "phase") && oGame.phase[oGame.phase_current] != "Pick") {
                  //tuto.forceNextStep();
             }
        }
        
        // Etape 1: Texte explication secret (Juste attendre le clic Suivant)
        else if (step_idx == 1) {
             // Rien à faire, le joueur lit le texte et clique sur Suivant
        }
        
        // Etape 2: Explication Envahisseur (Juste Highlight, pas d'action forcée)
        else if (step_idx == 2) {
             var target = noone;
             with(oCardParent) {
                 var instName = (variable_instance_exists(id, "name")) ? name : "";
                 var isEnvahisseur = (object_index == oEnvahisseurGueuleRoche) || (string_pos("Envahisseur", instName) > 0);
                 if (isEnvahisseur && isHeroOwner && (zone == "Hand" || zone == "HandSelected")) {
                     target = id;
                     break;
                 }
             }
             
             if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx - 8, yy - 8, w + 16, h + 16);
                 tuto.updateArrows([[xx + w/2, yy - 30, 270]]);
             }
        }

        // Etape 3: Sélectionner Envahisseur Gueule-Roche (Texte "Invoquez...")
        else if (step_idx == 3) {
             var target = noone;
             var isSelected = false;
             
             with(oCardParent) {
                 var instName = (variable_instance_exists(id, "name")) ? name : "";
                 var isEnvahisseur = (object_index == oEnvahisseurGueuleRoche) || (string_pos("Envahisseur", instName) > 0);
                 
                 if (isEnvahisseur && isHeroOwner && (zone == "Hand" || zone == "HandSelected")) {
                     target = id;
                     if (zone == "HandSelected") isSelected = true;
                     break;
                 }
             }
             
             if (instance_exists(oSelectManager) && oSelectManager.selected == target) {
                 isSelected = true;
             }
             
             if (isSelected) {
                 tuto.forceNextStep();
             } else if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx - 8, yy - 8, w + 16, h + 16);
                 tuto.updateArrows([[xx + w/2, yy - 30, 270]]);
             }
        }
        
        // Etape 4: Cliquer sur Summon
        else if (step_idx == 4) {
             // Vérifier D'ABORD si l'action a réussi (bouton cliqué = passage en mode placement)
             if (instance_exists(oUIManager) && oUIManager.selectedSummonOrSet == "Summon") {
                 tuto.forceNextStep();
                 return true;
             }

             var target = noone;
             if (instance_exists(oSummon)) target = instance_find(oSummon, 0);
             
             // Si le bouton n'existe plus (désélection) ET qu'on n'est pas passé en mode Summon, on retourne à l'étape 3
             if (target == noone) {
                 tuto.current_step = 3;
                 return true;
             }
             
             if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx - 10, yy - 10, w + 20, h + 20);
                 tuto.updateArrows([[xx + w/2, yy - 10, 270]]);
             }
        }
        
        // Etape 5: Placer sur le terrain
        else if (step_idx == 5) {
             // Highlight Field Zones
             var min_x = 99999, min_y = 99999, max_x = -99999, max_y = -99999;
             var found = false;
             
             with(oIndicatorParent) {
                 if (sprite_index != -1) {
                     found = true;
                     var w = sprite_get_width(sprite_index) * image_xscale;
                     var h = sprite_get_height(sprite_index) * image_yscale;
                     var ox = sprite_get_xoffset(sprite_index) * image_xscale;
                     var oy = sprite_get_yoffset(sprite_index) * image_yscale;
                     var xx = x - cam_x - ox; 
                     var yy = y - cam_y - oy;
                     
                     if (xx < min_x) min_x = xx;
                     if (yy < min_y) min_y = yy;
                     if (xx + w > max_x) max_x = xx + w;
                     if (yy + h > max_y) max_y = yy + h;
                 }
             }
             
             if (found) {
                  tuto.updateHighlight(min_x - 5, min_y - 5, (max_x - min_x) + 10, (max_y - min_y) + 10);
                  tuto.updateArrows([[min_x + (max_x - min_x)/2, min_y - 20, 270]]);
             }

             var target = noone;
             with(oCardParent) {
                 if (object_index == oEnvahisseurGueuleRoche && isHeroOwner && zone == "Field") {
                     target = id;
                     break;
                 }
             }
             
             if (target != noone) {
                 // HACK TUTORIEL: Donner la charge à l'Envahisseur pour qu'il puisse attaquer ce tour-ci
                 target.has_charge = true;
                 tuto.forceNextStep();
             }
        }
        
        // Etape 6: Transition texte (Ne plus demander de changer de phase car Phase Attaque n'existe plus)
        else if (step_idx == 6) {
             // On laisse juste le joueur cliquer sur Suivant (configuré dans Init)
        }
        
        // Etape 7: Sélectionner Peau-de-Roc Robuste
        else if (step_idx == 7) {
            // Check SKIP: Si Peau-de-Roc a déjà attaqué, on passe à la suite (Gobelin - Etape 10)
            var peauCheck = noone;
            with(oCardParent) { if((object_index == oPeauRocRobuste || object_index == oSanglierPeauRoc) && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) { peauCheck = id; break; } }
            if (peauCheck != noone && variable_instance_exists(peauCheck, "attacksUsedThisTurn") && peauCheck.attacksUsedThisTurn > 0) {
                 tuto.current_step = 10;
                 return true;
            }

            var target = noone;
            with(oCardParent) { if((object_index == oPeauRocRobuste || object_index == oSanglierPeauRoc) && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) target = id; }
            
            if (target != noone) {
                if (instance_exists(oSelectManager) && oSelectManager.selected == target) {
                    tuto.forceNextStep();
                } else {
                    var xx = target.bbox_left - cam_x;
                    var yy = target.bbox_top - cam_y;
                    var w = target.bbox_right - target.bbox_left;
                    var h = target.bbox_bottom - target.bbox_top;
                    tuto.updateHighlight(xx, yy, w, h);
                }
            }
        }
        
        // Etape 8: Bouton Attaquer (Peau-de-Roc)
        else if (step_idx == 8) {
             // Check SKIP
             var peauCheck = noone;
             with(oCardParent) { if((object_index == oPeauRocRobuste || object_index == oSanglierPeauRoc) && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) { peauCheck = id; break; } }
             if (peauCheck != noone && variable_instance_exists(peauCheck, "attacksUsedThisTurn") && peauCheck.attacksUsedThisTurn > 0) {
                 tuto.current_step = 10;
                 return true;
             }

             var btn = instance_find(oAttack, 0);
             if (btn != noone) {
                 var bx = btn.bbox_left - cam_x;
                 var by = btn.bbox_top - cam_y;
                 var bw = btn.bbox_right - btn.bbox_left;
                 var bh = btn.bbox_bottom - btn.bbox_top;
                 tuto.updateHighlight(bx, by, bw, bh);
             }
             
             if (instance_exists(oSelectManager) && oSelectManager.attackMode) {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 9: Attaquer Araignée (Peau-de-Roc) ou Direct
        else if (step_idx == 9) {
             var anyPeauAttacked = false;
             with(oCardParent) { 
                 if((object_index == oPeauRocRobuste || object_index == oSanglierPeauRoc) && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) { 
                     if (variable_instance_exists(id, "attacksUsedThisTurn") && attacksUsedThisTurn > 0) {
                         anyPeauAttacked = true;
                     }
                 } 
             }
             if (anyPeauAttacked) {
                 tuto.forceNextStep(); // Passera à 10 naturellement
                 return true;
             }

             var target = noone;
             with(oCardMonster) { 
                 var isEnemy = (variable_instance_exists(self, "isHeroOwner") && !isHeroOwner);
                 var onField = (variable_instance_exists(self, "zone") && (zone == "Field" || zone == "FieldSelected"));
                 var isFrontline = (variable_instance_exists(self, "fieldPosition") && self.fieldPosition <= 3);
                 
                 if (isEnemy && onField && isFrontline) { 
                     target = id; 
                 }
             }
             
             if (target != noone) {
                 var xx = target.bbox_left - cam_x;
                 var yy = target.bbox_top - cam_y;
                 var w = target.bbox_right - target.bbox_left;
                 var h = target.bbox_bottom - target.bbox_top;
                 tuto.updateHighlight(xx, yy, w, h);
             } else {
                 var atkDir = instance_find(oAttackDirectEnemy, 0);
                 if (atkDir != noone) {
                     var xx = atkDir.bbox_left - cam_x;
                     var yy = atkDir.bbox_top - cam_y;
                     var w = atkDir.bbox_right - atkDir.bbox_left;
                     var h = atkDir.bbox_bottom - atkDir.bbox_top;
                     tuto.updateHighlight(xx, yy, w, h);
                 }
             }
        }
        
        // Etape 10: Sélectionner Gobelin Furtif
        else if (step_idx == 10) {
            // Check SKIP: Si Gobelin a déjà attaqué, on passe à la suite (Envahisseur - Etape 13)
            var anyGobAttacked = false;
            with(oCardParent) { 
                var isGob = (object_index == oGobelinFurtif || (variable_instance_exists(id, "name") && string_pos("Gobelin", name) > 0));
                if(isGob && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) { 
                    if (variable_instance_exists(id, "attacksUsedThisTurn") && attacksUsedThisTurn > 0) {
                        anyGobAttacked = true;
                    }
                } 
            }
            if (anyGobAttacked) {
                 tuto.current_step = 13;
                 return true;
            }

            var target = noone;
            with(oCardParent) { 
                var isGob = (object_index == oGobelinFurtif || (variable_instance_exists(id, "name") && string_pos("Gobelin", name) > 0));
                if(isGob && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) target = id; 
            }
            
            if (target != noone) {
                if (instance_exists(oSelectManager) && oSelectManager.selected == target) {
                    tuto.forceNextStep();
                } else {
                    var xx = target.bbox_left - cam_x;
                    var yy = target.bbox_top - cam_y;
                    var w = target.bbox_right - target.bbox_left;
                    var h = target.bbox_bottom - target.bbox_top;
                    tuto.updateHighlight(xx, yy, w, h);
                }
            }
        }
        
        // Etape 11: Bouton Attaquer (Gobelin)
        else if (step_idx == 11) {
             // Check SKIP
             var anyGobAttacked = false;
             with(oCardParent) { 
                var isGob = (object_index == oGobelinFurtif || (variable_instance_exists(id, "name") && string_pos("Gobelin", name) > 0));
                if(isGob && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) { 
                    if (variable_instance_exists(id, "attacksUsedThisTurn") && attacksUsedThisTurn > 0) {
                        anyGobAttacked = true;
                    }
                } 
             }
             if (anyGobAttacked) {
                 tuto.current_step = 13;
                 return true;
             }

             var btn = instance_find(oAttack, 0);
             if (btn != noone) {
                 var bx = btn.bbox_left - cam_x;
                 var by = btn.bbox_top - cam_y;
                 var bw = btn.bbox_right - btn.bbox_left;
                 var bh = btn.bbox_bottom - btn.bbox_top;
                 tuto.updateHighlight(bx, by, bw, bh);
             }
             
             if (instance_exists(oSelectManager) && oSelectManager.attackMode) {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 12: Attaque Directe (Gobelin)
        else if (step_idx == 12) {
             var anyGobAttacked = false;
             with(oCardParent) { 
                var isGob = (object_index == oGobelinFurtif || (variable_instance_exists(id, "name") && string_pos("Gobelin", name) > 0));
                if(isGob && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) { 
                    if (variable_instance_exists(id, "attacksUsedThisTurn") && attacksUsedThisTurn > 0) {
                        anyGobAttacked = true;
                    }
                } 
             }
             if (anyGobAttacked) {
                 tuto.forceNextStep(); // Passera à 13
                 return true;
             }

             var atkDir = instance_find(oAttackDirectEnemy, 0);
             if (atkDir != noone) {
                 var xx = atkDir.bbox_left - cam_x;
                 var yy = atkDir.bbox_top - cam_y;
                 var w = atkDir.bbox_right - atkDir.bbox_left;
                 var h = atkDir.bbox_bottom - atkDir.bbox_top;
                 tuto.updateHighlight(xx, yy, w, h);
             }
        }
        
        // Etape 13: Sélectionner l'Envahisseur Gueule-Roche
        else if (step_idx == 13) {
             // Check SKIP: Si Envahisseur a déjà attaqué, on passe à la suite (Fin - Etape 16)
             var envCheck = noone;
             with(oCardParent) { if(object_index == oEnvahisseurGueuleRoche && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) { envCheck = id; break; } }
             if (envCheck != noone && variable_instance_exists(envCheck, "attacksUsedThisTurn") && envCheck.attacksUsedThisTurn > 0) {
                 tuto.current_step = 16;
                 return true;
             }

             var env = noone;
             with(oCardParent) { if(object_index == oEnvahisseurGueuleRoche && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) { env = id; break; } }
             
             if (env != noone) {
                 var isSelected = (instance_exists(oSelectManager) && oSelectManager.selected == env);
                 if (isSelected) {
                     tuto.forceNextStep();
                 } else {
                     var xx = env.bbox_left - cam_x;
                     var yy = env.bbox_top - cam_y;
                     var w = env.bbox_right - env.bbox_left;
                     var h = env.bbox_bottom - env.bbox_top;
                     tuto.updateHighlight(xx, yy, w, h);
                 }
             }
        }
        
        // Etape 14: Bouton Attaquer (Envahisseur)
        else if (step_idx == 14) {
             // Check SKIP
             var envCheck = noone;
             with(oCardParent) { if(object_index == oEnvahisseurGueuleRoche && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) { envCheck = id; break; } }
             if (envCheck != noone && variable_instance_exists(envCheck, "attacksUsedThisTurn") && envCheck.attacksUsedThisTurn > 0) {
                 tuto.current_step = 16;
                 return true;
             }

             var btn = instance_find(oAttack, 0);
             if (btn != noone) {
                 var bx = btn.bbox_left - cam_x;
                 var by = btn.bbox_top - cam_y;
                 var bw = btn.bbox_right - btn.bbox_left;
                 var bh = btn.bbox_bottom - btn.bbox_top;
                 tuto.updateHighlight(bx, by, bw, bh);
             }
             
             if (instance_exists(oSelectManager) && oSelectManager.attackMode) {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 15: Attaque directe (Envahisseur - Final)
        else if (step_idx == 15) {
             var env = noone;
             with(oCardParent) { if(object_index == oEnvahisseurGueuleRoche && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) { env = id; break; } }
             if (env != noone && variable_instance_exists(env, "attacksUsedThisTurn") && env.attacksUsedThisTurn > 0) {
                 tuto.forceNextStep(); // Passera à 16
                 return true;
             }

             var atkDir = instance_find(oAttackDirectEnemy, 0);
             if (atkDir != noone) {
                 var xx = atkDir.bbox_left - cam_x;
                 var yy = atkDir.bbox_top - cam_y;
                 var w = atkDir.bbox_right - atkDir.bbox_left;
                 var h = atkDir.bbox_bottom - atkDir.bbox_top;
                 tuto.updateHighlight(xx, yy, w, h);
             }
             
             if (instance_exists(oGameOverScreen) || instance_exists(oValiderDuel)) {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 16: Texte de félicitations
        else if (step_idx == 16) {
             // Attente du clic "Suivant"
        }
        
        // Etape 17: Bouton "Valider" de fin de duel
        else if (step_idx == 17) {
             var btnValider = instance_find(oValiderDuel, 0);
             if (btnValider != noone) {
                 var xx = btnValider.collision_left - cam_x;
                 var yy = btnValider.collision_top - cam_y;
                 var w = (btnValider.collision_right - btnValider.collision_left);
                 var h = (btnValider.collision_bottom - btnValider.collision_top);
                 tuto.updateHighlight(xx, yy, w, h);
             } else {
                 var gameOver = instance_find(oGameOverScreen, 0);
                 if (gameOver != noone) {
                     var bx = gameOver.buttonX - gameOver.buttonWidth/2;
                     var by = gameOver.buttonY - gameOver.buttonHeight/2;
                     tuto.updateHighlight(bx - cam_x, by - cam_y, gameOver.buttonWidth, gameOver.buttonHeight);
                 }
             }
        }
        
        return true;
    }
    return false;
}



/// @function Tutorial_Chapter0_Init()
/// @description Initialise le tutoriel du Chapitre 0 (Tour 1)
function Tutorial_Chapter0_Init() {
    if (variable_instance_exists(id, "tuto_turn1_done")) return;
    
    tuto_turn1_done = true;
    
    // Set Enemy HP to 5 for tutorial purposes
    var LP_Enemy_Instance = instance_find(oLP_Enemy, 0);
    if (LP_Enemy_Instance != noone) {
        LP_Enemy_Instance.nbLP = 5;
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
            text: "A vous de jouer ! Cliquez sur la carte 'Araignée Forestière' pour la sélectionner.",
            highlight: [0,0,0,0], // Sera mis à jour dynamiquement
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Le bouton 'Invoquer' (Summon) permet de placer le monstre en position d'Attaque (visible).",
            highlight: noone, // Sera mis à jour dynamiquement
            arrow: noone,
            allow_clicks: false
        },
        {
            text: "Le bouton 'Poser' (Set) permet de placer le monstre en position de Défense (caché).",
            highlight: noone, // Sera mis à jour dynamiquement
            arrow: noone,
            allow_clicks: false
        },
        {
            text: "Pour ce duel, nous allons jouer offensivement.\nCliquez sur le bouton 'Invoquer' pour continuer.",
            highlight: noone, // Sera mis à jour dynamiquement
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Choisissez un emplacement libre sur votre terrain pour invoquer le monstre.",
            highlight: noone, // Sera mis à jour dynamiquement
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Voici l'indicateur de Phase et de Tour.\nLe tour est divisé en 3 phases :\n1. Pioche: Vous piochez une carte.\n2. Main Phase: Vous jouez vos cartes.\n3. Combat: Vous attaquez l'adversaire.",
            highlight: [1605, 380, 250, 270],
            arrow: [1590, 515, 0]
        },
        {
            text: "Cliquez sur ce bouton pour passer à la phase de Combat.",
            highlight: noone, // Sera mis à jour dynamiquement
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Durant le premier tour, vous ne pouvez pas attaquer.\nCliquez à nouveau pour terminer votre tour.",
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
        
        // Etape 4: Sélection Araignée (Interactive)
        if (step_idx == 4) {
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
                         // Etape 15: Attaque Directe Gobelin
                         // REMOVED FROM HERE

        
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
        // Etape 5 (Explique Summon) ou 7 (Clic Summon)
        else if (step_idx == 5 || step_idx == 7) {
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
        // Etape 6 (Explique Set)
        else if (step_idx == 6) {
             var target = noone;
             if (instance_exists(oSet)) target = instance_find(oSet, 0);
             
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
            text: "C'est à votre tour ! Au début de chaque tour, vous devez piocher une carte.\nCliquez sur votre Deck pour piocher.",
            highlight: noone, // Sera mis à jour dynamiquement (Deck)
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Vous avez pioché une nouvelle carte !\nParlons des cartes Magie. Il en existe 4 types :",
            highlight: noone,
            arrow: noone
        },
        {
            text: "- Direct : Effet immédiat.\n- Continue : Reste sur le terrain.\n- Artéfact  : Equipement.\n- Secret : Se déclenche automatiquement sous condition une fois posé.",
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
            text: "Notez que les cartes Secret s'activent automatiquement si leur condition est remplie une fois posées sur le terrain.\n\nCliquez sur le bouton 'Poser' (Set) pour préparer la carte.",
            highlight: noone, // Sera mis à jour dynamiquement (oSet)
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Cliquez sur une zone Magie/Piège (ligne arrière) pour poser la carte.",
            highlight: noone, // Sera mis à jour dynamiquement (Terrain)
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
            text: "Passez maintenant en Phase de Combat (Battle).",
            highlight: h_phase, // Battle Button
            arrow: noone,
            hide_next_button: true
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
            text: "Lorsque deux monstres en position d'Attaque combattent et ont la même ATK, les deux sont détruits !\n\nSi l'attaque n'est pas égale, alors c'est celui avec le plus gros montant qui gagne et détruit le perdant en infligeant des dégâts au propriétaire.",
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
        
        // Etape 0: Piocher (Click Deck)
        if (step_idx == 0) {
            var deck = noone;
            with (oDeck) {
                if (isHeroOwner) { deck = id; break; }
            }
            
            if (deck != noone) {
                 var w = sprite_get_width(deck.sprite_index) * deck.image_xscale;
                 var h = sprite_get_height(deck.sprite_index) * deck.image_yscale;
                 var ox = sprite_get_xoffset(deck.sprite_index) * deck.image_xscale;
                 var oy = sprite_get_yoffset(deck.sprite_index) * deck.image_yscale;
                 var xx = deck.x - cam_x - ox;
                 var yy = deck.y - cam_y - oy;
                 
                 // Highlight Deck
                 tuto.updateHighlight(xx, yy, w, h);
                 tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
                 
                 // Vérifier si la phase a changé (l'action de pioche a été effectuée par le jeu)
                 if (variable_instance_exists(oGame, "phase") && oGame.phase[oGame.phase_current] != "Pick") {
                      tuto.forceNextStep();
                 }
            }
        }
        // Etape 3: Sélectionner Feuillage Protecteur
        else if (step_idx == 3) {
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
        // Etape 4: Cliquer sur le bouton Set (avec explication Secret)
        else if (step_idx == 4) {
             var target = noone;
             if (instance_exists(oSet)) target = instance_find(oSet, 0);
             
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
             
             // Vérifier si le mode Set est actif
             if (instance_exists(oUIManager) && oUIManager.selectedSummonOrSet == "Set") {
                 tuto.forceNextStep();
             }
        }

        // Etape 5: Poser Feuillage Protecteur
        else if (step_idx == 5) {
             // Highlight le terrain (Magic Zones)
             var min_x = 99999, min_y = 99999, max_x = -99999, max_y = -99999;
             var found = false;
             
             // On cible les zones Magie/Piège du héros
             with(oFieldMagicTrapHero) {
                 found = true;
                 if (sprite_index != -1) {
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
                 } else if (variable_instance_exists(id, "posLocation")) {
                     var cardW = 150;
                     var cardH = 210;
                     for (var i = 0; i < array_length(posLocation); i++) {
                         var pos = posLocation[i];
                         var xx = pos[0] - cam_x - cardW/2;
                         var yy = pos[1] - cam_y - cardH/2;
                         
                         if (xx < min_x) min_x = xx;
                         if (yy < min_y) min_y = yy;
                         if (xx + cardW > max_x) max_x = xx + cardW;
                         if (yy + cardH > max_y) max_y = yy + cardH;
                     }
                 }
             }
             
             if (found) {
                 var margin = 5;
                 tuto.updateHighlight(min_x - margin, min_y - margin, (max_x - min_x) + margin*2, (max_y - min_y) + margin*2);
                 tuto.updateArrows([[min_x + (max_x - min_x)/2, min_y - 20, 270]]);
             }
             
             // Vérifier si joué (sur le terrain)
             var played = false;
             with(oCardParent) {
                 if ((object_index == oFeuillageProtecteur || (variable_instance_exists(id, "name") && string_pos("Feuillage", name) > 0)) && 
                     zone == "Field" && isHeroOwner) {
                     played = true;
                     break;
                 }
             }
             if (played) {
                 show_debug_message("### TUTO TURN 3: Feuillage played!");
                 tuto.forceNextStep();
             }
        }
        // Etape 6: Invoquer Gobelin Furtif
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
        
        // Etape 8: Passer en Battle Phase
        else if (step_idx == 8) {
             // On attend que la phase devienne "Attack"
             if (variable_instance_exists(oGame, "phase") && oGame.phase[oGame.phase_current] == "Attack") {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 9: Selectionner Araignee
        else if (step_idx == 9) {
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
        
        // Etape 10: Cliquer Attack
        else if (step_idx == 10) {
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
        
        // Etape 11: Cibler Ennemi
        else if (step_idx == 11) {
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
        
        // Etape 13: Secret Highlight
        else if (step_idx == 13) {
             var secret = noone;
             with(oFeuillageProtecteur) {
                 if (isHeroOwner && zone == "Field") secret = id;
             }
             if (secret != noone) {
                 var bx = secret.bbox_left - cam_x;
                 var by = secret.bbox_top - cam_y;
                 var bw = secret.bbox_right - secret.bbox_left;
                 var bh = secret.bbox_bottom - secret.bbox_top;
                 tuto.updateHighlight(bx, by, bw, bh);
             }
        }
        // Etape 14: Fin de tour
        else if (step_idx == 14) {
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
            text: "C'est à votre tour ! Commencez par piocher une carte.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Un effet 'Crépuscule' se déclenche automatiquement à la fin de votre tour.\nÀ l'inverse, un effet 'Aube' s'activerait au début du tour.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Justement, le Maître des Passes possède un effet Crépuscule, essayons-le.",
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
        {
            text: "Bien joué ! Passez maintenant en phase d'Attaque.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
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
            text: "Observez le résultat : Votre attaque (4) est inférieure à sa défense (6).\nVous subissez la différence (2) en dégâts.\nSi votre ATK est égale à la DEF ennemi, alors il ne se passe rien.\nSi votre ATK est supérieur à la DEF adverse alors son monstre est détruit mais aucun dégat n'est subis.",
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
        
        // Etape 0: Piocher
        if (step_idx == 0) {
            var deck = noone;
            with (oDeck) {
                if (isHeroOwner) { deck = id; break; }
            }
            
            if (deck != noone) {
                 var w = sprite_get_width(deck.sprite_index) * deck.image_xscale;
                 var h = sprite_get_height(deck.sprite_index) * deck.image_yscale;
                 var ox = sprite_get_xoffset(deck.sprite_index) * deck.image_xscale;
                 var oy = sprite_get_yoffset(deck.sprite_index) * deck.image_yscale;
                 var xx = deck.x - cam_x - ox;
                 var yy = deck.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx, yy, w, h);
                 tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
                 
                 // Wait for phase change (Pick -> Main)
                 if (variable_instance_exists(oGame, "phase") && oGame.phase[oGame.phase_current] != "Pick") {
                      tuto.forceNextStep();
                 }
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
        
        // Etape 6: Passer en Phase Attaque
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
        
        // Etape 7: Sélectionner Gobelin Furtif
        else if (step_idx == 7) {
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
        
        // Etape 8: Cliquer sur Attaquer
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
        
        // Etape 9: Attaquer Tortue Vagabonde
        else if (step_idx == 9) {
             // Init tracking HP variable
             if (!variable_instance_exists(tuto, "hp_start_step_9")) {
                 var lp_obj = instance_find(oLP_Hero, 0);
                 tuto.hp_start_step_9 = (lp_obj != noone) ? lp_obj.nbLP : 100;
             }
             
             // Check HP drop
             var current_hp = 100;
             var lp_obj = instance_find(oLP_Hero, 0);
             if (lp_obj != noone) current_hp = lp_obj.nbLP;
             
             if (current_hp < tuto.hp_start_step_9) {
                 tuto.forceNextStep();
             }

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
             
             if (gobelin != noone && variable_instance_exists(gobelin, "hasAttacked") && gobelin.hasAttacked) {
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
        
        // Etape 11: Fin de tour (skip step 10 car c'est juste du texte)
        else if (step_idx == 11) {
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
    tuto.tutorial_id = 7; // ID pour le Tour 7
    
    var steps = [
        {
            text: "C'est le tour 7 ! Commencez par piocher une carte.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
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
            text: "Le Peau-de-Roc Robuste dans votre main possède un effet Eveil.\nSélectionnez-le.",
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
            text: "Regardez ! Son attaque a augmenté grâce à son effet Eveil.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Passez maintenant en phase d'Attaque.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
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
        
        // Etape 0: Piocher
        if (step_idx == 0) {
            var deck = noone;
            with (oDeck) {
                if (isHeroOwner) { deck = id; break; }
            }
            
            if (deck != noone) {
                 var w = sprite_get_width(deck.sprite_index) * deck.image_xscale;
                 var h = sprite_get_height(deck.sprite_index) * deck.image_yscale;
                 var ox = sprite_get_xoffset(deck.sprite_index) * deck.image_xscale;
                 var oy = sprite_get_yoffset(deck.sprite_index) * deck.image_yscale;
                 var xx = deck.x - cam_x - ox;
                 var yy = deck.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx, yy, w, h);
                 tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
                 
                 // Wait for phase change (Pick -> Main)
                 if (variable_instance_exists(oGame, "phase") && oGame.phase[oGame.phase_current] != "Pick") {
                      tuto.forceNextStep();
                 }
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
        
        // Etape 7: Passer en Phase Attaque
        else if (step_idx == 7) {
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
        
        // Etape 8: Sélectionner Peau-de-Roc Robuste
        else if (step_idx == 8) {
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
        
        // Etape 9: Cliquer sur Attaquer
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
        
        // Etape 10: Attaquer Tortue Vagabonde
        else if (step_idx == 10) {
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
        
        // Etape 11: Fin de tour
        else if (step_idx == 11) {
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
    
    // Set Enemy HP to 5 for tutorial purposes (redundant check)
    var LP_Enemy_Instance = instance_find(oLP_Enemy, 0);
    if (LP_Enemy_Instance != noone) {
        LP_Enemy_Instance.nbLP = 5;
    }

    show_debug_message("### TUTO TURN 9: Init started");
    
    var tuto = instance_create_layer(0, 0, "UI", oTutorielManager);
    tuto.tutorial_id = 9; // ID pour le Tour 9
    
    var steps = [
        {
            text: "C'est le tour 9 ! Commencez par piocher une carte.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Votre secret 'Feuillage Protecteur' s'est activé durant le tour adverse !\nLe Maître des Passes a été attaqué, ce qui a déclenché le piège.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Maintenant, parlons des Sacrifices.\nPour invoquer un monstre de Niveau 2, vous devez sacrifier 1 monstre.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Pour un monstre de Niveau 3, il faut 2 sacrifices.\nL'Envahisseur Gueule-Roche est de Niveau 2.",
            highlight: noone,
            arrow: noone
        },
        {
            text: "Sélectionnez l'Envahisseur Gueule-Roche dans votre main.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Pour l'invoquer, cliquez sur 'Invoquer', sélectionnez le 'Maître des Passes' comme sacrifice, puis validez.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "C'est validé ! Vous avez sacrifié votre monstre pour en invoquer un plus puissant.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true // Passera automatiquement
        },
        {
            text: "Vous avez maintenant une puissante créature ! Equipons le Peau-de-Roc Robuste pour le renforcer.\nSélectionnez 'Griffe de Prédateur' dans votre main.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Cliquez sur le bouton 'Activer' pour équiper la carte.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Choisissez un emplacement libre sur le terrain Magie/Piège pour poser la carte.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Choisissez le Peau-de-Roc Robuste comme cible de l'équipement.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Parfait ! Il est temps de passer à l'attaque.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Sélectionnez votre Gobelin Furtif sur le terrain.",
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
            text: "Attaquez l'Araignée Forestière en Défense avec le Gobelin.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Sélectionnez votre Envahisseur Gueule-Roche sur le terrain.",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Cliquez sur le bouton 'Attaquer' (Envahisseur).",
            highlight: noone,
            arrow: noone,
            hide_next_button: true
        },
        {
            text: "Attaquez directement l'adversaire. L'emplacement est mis en évidence.",
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
        
        // Etape 0: Piocher
        if (step_idx == 0) {
            var deck = noone;
            with (oDeck) {
                if (isHeroOwner) { deck = id; break; }
            }
            
            if (deck != noone) {
                 var w = sprite_get_width(deck.sprite_index) * deck.image_xscale;
                 var h = sprite_get_height(deck.sprite_index) * deck.image_yscale;
                 var ox = sprite_get_xoffset(deck.sprite_index) * deck.image_xscale;
                 var oy = sprite_get_yoffset(deck.sprite_index) * deck.image_yscale;
                 var xx = deck.x - cam_x - ox;
                 var yy = deck.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx, yy, w, h);
                 tuto.updateArrows([[xx + w/2, yy - 20, 270]]);
                 
                 // Wait for phase change (Pick -> Main)
                 if (variable_instance_exists(oGame, "phase") && oGame.phase[oGame.phase_current] != "Pick") {
                      tuto.forceNextStep();
                 }
            }
        }
        
        // Etape 4: Sélectionner Envahisseur Gueule-Roche
        else if (step_idx == 4) {
             var target = noone;
             var isSelected = false;
             
             with(oCardParent) {
                 if (object_index == oEnvahisseurGeuleRoche && (zone == "Hand" || zone == "HandSelected") && isHeroOwner) {
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
        
        // Etape 5: Invoquer Envahisseur Gueule-Roche (Sacrifice)
        else if (step_idx == 5) {
             // On s'assure que tout l'écran est accessible pour cliquer sur Invoquer puis gérer le sacrifice
             var vw = camera_get_view_width(view_camera[0]);
             var vh = camera_get_view_height(view_camera[0]);
             tuto.updateHighlight(0, 0, vw, vh);
             tuto.updateArrows(noone);

             // On vérifie si l'Envahisseur Gueule-Roche a bien été invoqué sur le terrain
             var isSummoned = false;
             with(oCardParent) {
                 if (object_index == oEnvahisseurGeuleRoche && (zone == "Field" || zone == "FieldSelected") && isHeroOwner) {
                     isSummoned = true;
                     break;
                 }
             }
             
             if (isSummoned) {
                 // Si invoqué, on passe directement l'étape 5 ET l'étape 6 (validation sacrifice)
                 // car l'invocation implique que le sacrifice a été fait et validé
                 tuto.current_step = 7; // Saut vers l'étape 7 (Equiper Griffe)
             }
        }
        
        // Etape 6: (Obsolète car sauté par étape 5, mais gardé en fallback)
        else if (step_idx == 6) {
             tuto.forceNextStep();
        }
        
        // Etape 7: Sélectionner Griffe de Prédateur
        else if (step_idx == 7) {
             var target = noone;
             var isSelected = false;
             
             with(oCardParent) {
                 if (object_index == oGriffePredateur && (zone == "Hand" || zone == "HandSelected") && isHeroOwner) {
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
        
        // Etape 8: Cliquer Activer
        else if (step_idx == 8) {
             var target = noone;
             if (instance_exists(oEffectButton)) target = instance_find(oEffectButton, 0); 
             // Fallback to oSummon if oEffectButton doesn't exist (sometimes shared logic)
             if (target == noone && instance_exists(oSummon)) target = instance_find(oSummon, 0);
             
             if (target != noone) {
                 var w = sprite_get_width(target.sprite_index) * target.image_xscale;
                 var h = sprite_get_height(target.sprite_index) * target.image_yscale;
                 var ox = sprite_get_xoffset(target.sprite_index) * target.image_xscale;
                 var oy = sprite_get_yoffset(target.sprite_index) * target.image_yscale;
                 var xx = target.x - cam_x - ox;
                 var yy = target.y - cam_y - oy;
                 
                 tuto.updateHighlight(xx, yy, w, h);
                 tuto.updateArrows([[xx + w/2, yy - 10, 270]]);
             }
             
             // Wait for equip target selection mode
             if (instance_exists(oSelectManager) && variable_instance_exists(oSelectManager, "mode") && oSelectManager.mode == "EquipTarget") {
                  tuto.forceNextStep();
             }
             // Or if we clicked button
             if (instance_exists(oUIManager) && (oUIManager.selectedSummonOrSet == "Activate" || oUIManager.selectedSummonOrSet == "Summon")) {
                  tuto.forceNextStep();
             }
        }
        
        // Etape 9: Choisir un emplacement Magic/Piège
        else if (step_idx == 9) {
             var spellOnField = false;
             with(oCardParent) {
                  if (object_index == oGriffePredateur && zone == "Field" && isHeroOwner) spellOnField = true;
             }
             
             if (spellOnField) {
                  tuto.forceNextStep();
             } else {
                  var fld = instance_find(oFieldMagicTrapHero, 0);
                  if (fld != noone && variable_instance_exists(fld, "posLocation")) {
                       var pos = fld.posLocation[0];
                       var xx = pos[0] - cam_x - 80;
                       var yy = pos[1] - cam_y - 80;
                       var w = 160;
                       var h = 160;
                       tuto.updateHighlight(xx, yy, w, h);
                  }
             }
        }
        
        // Etape 10: Choisir Cible Equipement (Peau-de-Roc Robuste)
        else if (step_idx == 10) {
             var target = noone;
             with(oCardParent) {
                  if (object_index == oPeauRocRobuste && zone == "Field" && isHeroOwner) {
                      target = id;
                      break;
                  }
             }
             
             if (target != noone) {
                 // Vérifier que la Griffe est posée ET équipée à Peau-de-Roc
                 var isEquipped = false;
                 var griffe = noone;
                 with(oCardParent) {
                      if (object_index == oGriffePredateur && isHeroOwner && zone == "Field") {
                           griffe = id;
                           break;
                      }
                 }
                 if (griffe != noone && variable_instance_exists(griffe, "equipped_target") && griffe.equipped_target == target) {
                      isEquipped = true;
                 }
                 if (isEquipped) {
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
        
        // Etape 11: Passer en Phase Attaque
        else if (step_idx == 11) {
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
        
        // Etape 12: Transition vers l'attaque (déjà existant)
        else if (step_idx == 12) {
            var gobelin = noone;
            with(oCardParent) { if(object_index == oGobelinFurtif && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) gobelin = id; }
            
            // Cette étape ne force rien, elle prépare la transition vers la sélection du Gobelin (étape 13)
            if (gobelin != noone) {
                // FIX: Si le joueur sélectionne le Gobelin ici, on passe à la suite (évite d'être bloqué)
                if (instance_exists(oSelectManager) && oSelectManager.selected == gobelin) {
                    tuto.forceNextStep();
                } else {
                    var xx = gobelin.bbox_left - cam_x;
                    var yy = gobelin.bbox_top - cam_y;
                    var w = gobelin.bbox_right - gobelin.bbox_left;
                    var h = gobelin.bbox_bottom - gobelin.bbox_top;
                    tuto.updateHighlight(xx, yy, w, h);
                }
            }
        }
        
        // Etape 13: Bouton Attaquer (Gobelin)
        else if (step_idx == 13) {
             var attacker = noone;
             with(oCardParent) { if(object_index == oGobelinFurtif && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) { attacker = id; break; } }
             
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
        
        // Etape 14: Attaquer Araignée Forestière en Défense
        else if (step_idx == 14) {
             var target = noone;
             // Utilisation de oCardMonster pour détecter tout monstre adverse (plus robuste)
             with(oCardMonster) { 
                 var isEnemy = (variable_instance_exists(self, "isHeroOwner") && !isHeroOwner);
                 var onField = (variable_instance_exists(self, "zone") && (zone == "Field" || zone == "FieldSelected"));
                 
                 if (isEnemy && onField) { 
                     target = id; 
                 }
             }
             
             if (target == noone) {
                 tuto.forceNextStep();
             } else {
                 var xx = target.bbox_left - cam_x;
                 var yy = target.bbox_top - cam_y;
                 var w = target.bbox_right - target.bbox_left;
                 var h = target.bbox_bottom - target.bbox_top;
                 tuto.updateHighlight(xx, yy, w, h);
             }
        }
        
        // Etape 15: Sélectionner l'Envahisseur Gueule-Roche
        else if (step_idx == 15) {
             var env = noone;
             with(oCardParent) { if(object_index == oEnvahisseurGeuleRoche && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) { env = id; break; } }
             
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
        
        // Etape 16: Bouton Attaquer (Envahisseur)
        else if (step_idx == 16) {
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
        
        // Etape 17: Attaque directe (mise en évidence de l'emplacement)
        else if (step_idx == 17) {
             var atkDir = instance_find(oAttackDirectEnemy, 0);
             if (atkDir != noone) {
                 var xx = atkDir.bbox_left - cam_x;
                 var yy = atkDir.bbox_top - cam_y;
                 var w = atkDir.bbox_right - atkDir.bbox_left;
                 var h = atkDir.bbox_bottom - atkDir.bbox_top;
                 tuto.updateHighlight(xx, yy, w, h);
             }
             
             // Detection Victoire / Fin de Duel
             if (instance_exists(oGameOverScreen) || instance_exists(oValiderDuel)) {
                 tuto.forceNextStep();
             }
             
             if (!variable_instance_exists(tuto, "turn9_step17_lp_start")) {
                 var lp0 = instance_find(oLP_Enemy, 0);
                 tuto.turn9_step17_lp_start = (lp0 != noone) ? lp0.nbLP : 100;
             }
             var lpInst = instance_find(oLP_Enemy, 0);
             var lpNow = (lpInst != noone) ? lpInst.nbLP : 100;
             if (lpNow < tuto.turn9_step17_lp_start) {
                 tuto.forceNextStep();
             }
             var env = noone;
             with(oCardParent) { if(object_index == oEnvahisseurGeuleRoche && isHeroOwner && (zone == "Field" || zone == "FieldSelected")) { env = id; break; } }
             if (env != noone && variable_instance_exists(env, "attacksUsedThisTurn") && env.attacksUsedThisTurn > 0) {
                 tuto.forceNextStep();
             }
        }
        
        // Etape 18: Texte de félicitations (pas d'action)
        else if (step_idx == 18) {
             // Attente du clic "Suivant"
        }
        
        // Etape 19: Bouton "Valider" de fin de duel
        else if (step_idx == 19) {
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

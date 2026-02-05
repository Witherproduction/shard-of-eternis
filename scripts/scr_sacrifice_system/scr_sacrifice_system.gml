// Fonction pour déterminer le niveau de sacrifice requis basé sur le niveau d'étoile du monstre
function getSacrificeLevel(mana_cost) {
    // SYSTÈME DE SACRIFICE DÉSACTIVÉ
    // Tous les monstres peuvent être invoqués sans sacrifice, quel que soit leur niveau.
    return 0; 
}

// Fonction pour effectuer les sacrifices (déplacer les cartes vers le cimetière)
function performSacrifices(sacrificeList, isHero) {
    // Indicateur global: un sacrifice est en cours (pour filtrer certains triggers)
    global.sacrifice_in_progress = true;
    for (var i = 0; i < array_length(sacrificeList); i++) {
        var sacrificeCard = sacrificeList[i];
        if (instance_exists(sacrificeCard)) {
            // Déclencher les triggers liés à la sortie et destruction (avec contexte sacrifice)
            registerTriggerEvent(TRIGGER_LEAVE_FIELD, sacrificeCard, { from_sacrifice: true, owner_is_hero: isHero });
            registerTriggerEvent(TRIGGER_ON_DESTROY, sacrificeCard, { from_sacrifice: true });
            // Trouver le bon cimetière
            var graveyard = noone;
            with (oGraveyard) {
                if (isHero) {
                    // Cimetière héros aux coordonnées (1514.7029, 688.0)
                    if (abs(x - 1514.7029) < 1 && abs(y - 688.0) < 1) {
                        graveyard = id;
                    }
                } else {
                    // Cimetière ennemi aux coordonnées (452.9149, 282.0)
                    if (abs(x - 452.9149) < 1 && abs(y - 282.0) < 1) {
                        graveyard = id;
                    }
                }
            }
            
            // Ajouter la carte au cimetière
            if (graveyard != noone) {
                graveyard.addToGraveyard(sacrificeCard);
                if (instance_exists(sacrificeCard)) sacrificeCard.zone = "Graveyard";
                registerTriggerEvent(TRIGGER_ENTER_GRAVEYARD, sacrificeCard, { owner_is_hero: isHero });
            }
            
            // Retirer la carte du terrain
            if (isHero) {
                fieldManagerHero.remove(sacrificeCard);
            } else {
                fieldManagerEnemy.remove(sacrificeCard);
            }
            
            // Ajouter animation de destruction
            var fx = instance_create_layer(sacrificeCard.x, sacrificeCard.y, "Instances", FX_Destruction);
            if (fx != noone) {
                fx.spriteGhost   = sacrificeCard.sprite_index;
                fx.imageGhost    = sacrificeCard.image_index;
                fx.image_xscale  = sacrificeCard.image_xscale;
                fx.image_yscale  = sacrificeCard.image_yscale;
                fx.image_angle   = sacrificeCard.image_angle;
                fx.duration_ms   = 700;
                fx.sep_px        = 48;
                fx.strip_h       = 3;
                fx.ragged_amp_px = 6;
                fx.depth_override = -100000;
            }
            
            // Détruire l'instance
            with(sacrificeCard) {
                instance_destroy();
            }
        }
    }
    // Fin du sacrifice
    global.sacrifice_in_progress = false;
}

// Fonction pour vérifier si on peut invoquer avec les sacrifices disponibles
function canSummonWithSacrifices(monsterStar, availableSacrifices) {
    var requiredLevel = getSacrificeLevel(monsterStar);
    
    if (requiredLevel == 0) {
        return true; // Pas de sacrifice requis
    }
    
    if (requiredLevel == 1) {
        // Besoin d'1 sacrifice (n'importe quel niveau)
        return array_length(availableSacrifices) >= 1;
    }
    
    if (requiredLevel == 2) {
        // Besoin de 2 sacrifices (n'importe quel niveau)
        return array_length(availableSacrifices) >= 2;
    }
    
    return false;
}

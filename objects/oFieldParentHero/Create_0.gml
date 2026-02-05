show_debug_message("### oFieldParentHero.create - before event_inherited")
event_inherited();
show_debug_message("### oFieldParentHero.create - after event_inherited")
	

///////////////////////////////////////////////////////////////////////
// Méthodes
///////////////////////////////////////////////////////////////////////

#region Function addIndicators
addIndicators = function() {show_debug_message("### oFieldParentHero.addIndicators")
	
	// Définit la liste des objets indicateurs de base (pour les indices 0-4)
	var indicators_base = type == "Monster" ? [oM0, oM1, oM2, oM3, oM4] : [oT0, oT1, oT2, oT3, oT4];
	
	// Limiter la boucle au nombre d'emplacements définis (évite crash si cards > posLocation)
	var limit = array_length(posLocation);
	if (array_length(cards) < limit) limit = array_length(cards);

	// Créer les indicateurs
	for (var i=0; i<limit; i++) {
		if(!cards[i]) {
			var obj = noone;
			
			// Utiliser l'objet spécifique s'il existe dans la liste de base
			if (i < array_length(indicators_base)) {
				obj = indicators_base[i];
			} else {
				// Fallback pour les slots supplémentaires (ex: 5, 6, 7 pour les monstres)
				// On réutilise le premier indicateur comme base
				obj = indicators_base[0];
			}
			
			if (obj != noone) {
				var inst = instance_create_layer(posLocation[i][0], posLocation[i][1], layer_get_id("Instances"), obj);
				// Mettre à jour la position logique pour correspondre à l'index réel
				inst.fieldPosition = string(i);
				inst.type = type;
			}
		}
	}
}
#endregion

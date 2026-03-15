/// @function regenerate_database_from_objects()
/// @description Scanne tous les objets du projet, identifie les cartes (enfants de oCardParent),
/// extrait leurs variables par défaut et régénère cards_database.json.
/// À UTILISER UNIQUEMENT EN DÉVELOPPEMENT pour synchroniser l'IDE et le JSON.
function regenerate_database_from_objects() {
    show_debug_message("### DÉBUT GÉNÉRATION DATABASE DEPUIS OBJETS ###");
    
    var new_db = {};
    var count = 0;
    
    // On suppose que les index d'objets sont contigus ou presque.
    // On scanne une large plage pour être sûr.
    var max_scan = 10000; 
    
    for (var i = 0; i < max_scan; i++) {
        if (object_exists(i)) {
            // Vérifier si c'est un enfant de oCardParent (et pas oCardParent lui-même)
            if (object_is_ancestor(i, oCardParent)) {
                var obj_name = object_get_name(i);
                
                // Ignorer les objets abstraits ou techniques si nécessaire
                if (string_pos("Parent", obj_name) > 0 || string_pos("Manager", obj_name) > 0) continue;
                
                // Instancier pour lire les valeurs par défaut définies dans l'IDE (Variable Definitions / Create)
                // On le place hors écran
                var inst = instance_create_depth(-10000, -10000, 0, i);
                
                if (inst != noone) {
                    try {
                        // Extraction des données
                        var card_data = {};
                        
                        // 1. Identifiants
                        card_data.objectId = obj_name;
                        
                        // Nom : si pas de nom, utiliser le nom de l'objet sans 'o'
                        var c_name = variable_instance_exists(inst, "name") ? inst.name : "";
                        if (c_name == "") {
                            c_name = string_delete(obj_name, 1, 1); // Enlever le 'o'
                        }
                        card_data.name = c_name;
                        
                        // ID unique (snake_case)
                        var c_id = variable_instance_exists(inst, "id") ? inst.id : ""; // id interne GML (réel) ou variable 'id' (string)?
                        // Attention: 'id' est une variable intégrée (instance id). Les cartes ont souvent une variable 'card_id' ou on la génère.
                        // Dans le JSON actuel, "id" est une string (ex: "maree_deferlante").
                        // On va générer un ID propre basé sur le nom si non défini explicitement comme string
                        if (!is_string(c_id)) {
                            c_id = string_lower(c_name);
                            c_id = string_replace_all(c_id, " ", "_");
                            c_id = string_replace_all(c_id, "'", "");
                            // Nettoyage accents basique pour l'ID
                            c_id = string_replace_all(c_id, "é", "e");
                            c_id = string_replace_all(c_id, "è", "e");
                            c_id = string_replace_all(c_id, "ê", "e");
                            c_id = string_replace_all(c_id, "à", "a");
                        }
                        card_data.id = c_id;
                        
                        // 2. Propriétés visuelles
                        if (variable_instance_exists(inst, "sprite_index") && inst.sprite_index != -1) {
                            card_data.sprite = sprite_get_name(inst.sprite_index);
                        } else {
                            card_data.sprite = "sprInvisible";
                        }
                        
                        // 3. Stats et Gameplay
                        card_data.type = variable_instance_exists(inst, "type") ? inst.type : "Unit";
                        card_data.mana_cost = variable_instance_exists(inst, "mana_cost") ? inst.mana_cost : 0;
                        card_data.description = variable_instance_exists(inst, "description") ? inst.description : "";
                        
                        // Stats combat (seulement si pertinent, mais on met tout pour être sûr)
                        card_data.attack = variable_instance_exists(inst, "attack") ? inst.attack : 0;
                        card_data.PV = variable_instance_exists(inst, "PV") ? inst.PV : 0;
                        
                        // 4. Métadonnées
                        card_data.rarity = variable_instance_exists(inst, "rarity") ? inst.rarity : "commun";
                        card_data.race = variable_instance_exists(inst, "race") ? inst.race : "";
                        card_data.booster = variable_instance_exists(inst, "booster") ? inst.booster : "Base";
                        card_data.genre = variable_instance_exists(inst, "genre") ? inst.genre : "";
                        
                        // Tags (tableau)
                        if (variable_instance_exists(inst, "tags")) {
                            card_data.tags = inst.tags;
                        } else {
                            card_data.tags = [];
                        }
                        
                        // Ajout à la nouvelle DB
                        new_db[$ c_id] = card_data;
                        count++;
                        
                        show_debug_message("SCAN: Ajout " + obj_name + " -> " + c_id);
                        
                    } catch(e) {
                        show_debug_message("SCAN ERROR sur " + obj_name + ": " + string(e));
                    } finally {
                        // Nettoyage
                        instance_destroy(inst);
                    }
                }
            }
        }
    }
    
    show_debug_message("### SCAN TERMINÉ : " + string(count) + " cartes trouvées. ###");
    
    // Sauvegarde dans le fichier
    if (count > 0) {
        var db_struct = {
            version: "2.0 (Auto-Gen)",
            cards_database: new_db,
            save_date: date_current_datetime(),
            total_cards: count
        };
        
        var json_str = json_stringify(db_struct);
        
        // Ecriture forcée
        var path = CARDS_DATABASE_SAVE_FILE; // datafiles/cards_database.json
        var f = file_text_open_write(path);
        if (f != -1) {
            file_text_write_string(f, json_str);
            file_text_close(f);
            show_debug_message("### DATABASE RÉGÉNÉRÉE ET SAUVEGARDÉE DANS " + path + " ###");
            
            // Mise à jour de l'instance oDataBase courante si elle existe
            var db_inst = instance_find(oDataBase, 0);
            if (db_inst != noone) {
                db_inst.cardDatabase = new_db;
                show_debug_message("### Instance oDataBase mise à jour à chaud ###");
            }
            
            return true;
        }
    }
    
    return false;
}

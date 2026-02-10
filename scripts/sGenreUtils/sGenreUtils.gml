// Utilitaires pour vérifier les conditions liées aux genres

/// @function has_genre_monster_on_field(is_hero_owner, genre_name)
/// @description Vérifie s'il existe au moins un monstre d'un genre donné sur le terrain du propriétaire indiqué
/// @param {bool} is_hero_owner - true pour le héros, false pour l'ennemi
/// @param {string} genre_name - nom du genre à tester (insensible à la casse)
/// @returns {bool}
function has_genre_monster_on_field(is_hero_owner, genre_name) {
    var target = string_lower(genre_name);
    target = string_replace_all(target, "ê", "e");
    target = string_replace_all(target, "é", "e");
    target = string_replace_all(target, "è", "e");

    var found = false;
    with (oCardMonster) {
        if (zone == "Field" && isHeroOwner == is_hero_owner) {
            if (variable_instance_exists(self, "genre")) {
                var g = string_lower(genre);
                g = string_replace_all(g, "ê", "e");
                g = string_replace_all(g, "é", "e");
                g = string_replace_all(g, "è", "e");
                
                if (g == target) {
                    found = true;
                }
            }
        }
    }
    return found;
}
// Utilitaires pour vérifier les conditions liées aux archétypes

/// @function has_archetype_monster_on_field(is_hero_owner, archetype_name)
/// @description Vérifie s'il existe au moins un monstre d'un archétype donné sur le terrain du propriétaire indiqué
/// @param {bool} is_hero_owner - true pour le héros, false pour l'ennemi
/// @param {string} archetype_name - nom de l'archetype à tester (insensible à la casse)
/// @returns {bool}
function has_archetype_monster_on_field(is_hero_owner, archetype_name) {
    var target = string_lower(archetype_name);
    target = string_replace_all(target, "ê", "e");
    target = string_replace_all(target, "é", "e");
    target = string_replace_all(target, "è", "e");

    var found = false;
    with (oCardMonster) {
        if (zone == "Field" && isHeroOwner == is_hero_owner) {
            if (variable_instance_exists(self, "archetype")) {
                var a = string_lower(archetype);
                a = string_replace_all(a, "ê", "e");
                a = string_replace_all(a, "é", "e");
                a = string_replace_all(a, "è", "e");

                if (a == target) {
                    found = true;
                }
            }
        }
    }
    return found;
}


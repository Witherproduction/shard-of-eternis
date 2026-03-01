// Utilitaires pour vérifier les conditions liées aux races

/// @function has_race_monster_on_field(is_hero_owner, race_name)
/// @description Vérifie s'il existe au moins un monstre d'une race donnée sur le terrain du propriétaire indiqué
/// @param {bool} is_hero_owner - true pour le héros, false pour l'ennemi
/// @param {string} race_name - nom de la race à tester (insensible à la casse)
/// @returns {bool}
function has_race_monster_on_field(is_hero_owner, race_name) {
    var target = string_lower(race_name);
    target = string_replace_all(target, "ê", "e");
    target = string_replace_all(target, "é", "e");
    target = string_replace_all(target, "è", "e");

    var found = false;
    with (oCardMonster) {
        if (zone == "Field" && isHeroOwner == is_hero_owner) {
            if (variable_instance_exists(self, "race")) {
                var a = string_lower(race);
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

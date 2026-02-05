// === oLayoutDebugger - Step Event ===

// Toggle activation avec F3
if (keyboard_check_pressed(vk_f3)) {
    active = !active;
}

// Mettre à jour la visibilité globale des cadres
global.show_green_frames = active;

if (!active) exit;

// Changement de champ (Tab)
if (keyboard_check_pressed(vk_tab)) {
    current_field_index = (current_field_index + 1) % array_length(fields);
}

// Mettre à jour le champ sélectionné pour le debug
global.debug_selected_field = fields[current_field_index];

// Changement de mode édition (Espace)
if (keyboard_check_pressed(vk_space)) {
    edit_mode = (edit_mode + 1) % 4;
}

// Vitesse de déplacement
var spd = 1;
if (keyboard_check(vk_shift)) spd = 10;

// Modification des valeurs
var field_name = fields[current_field_index];
var layout_struct = variable_struct_get(global.card_layout, field_name);

if (keyboard_check_pressed(vk_left) || keyboard_check(vk_left)) {
    if (edit_mode == 0) layout_struct.x1 -= spd;
    if (edit_mode == 1) layout_struct.y1 -= spd;
    if (edit_mode == 2) layout_struct.x2 -= spd;
    if (edit_mode == 3) layout_struct.y2 -= spd;
}
if (keyboard_check_pressed(vk_right) || keyboard_check(vk_right)) {
    if (edit_mode == 0) layout_struct.x1 += spd;
    if (edit_mode == 1) layout_struct.y1 += spd;
    if (edit_mode == 2) layout_struct.x2 += spd;
    if (edit_mode == 3) layout_struct.y2 += spd;
}
if (keyboard_check_pressed(vk_up) || keyboard_check(vk_up)) {
    // Up diminue Y
    if (edit_mode == 1 || edit_mode == 3) {
        if (edit_mode == 1) layout_struct.y1 -= spd;
        if (edit_mode == 3) layout_struct.y2 -= spd;
    }
}
if (keyboard_check_pressed(vk_down) || keyboard_check(vk_down)) {
    // Down augmente Y
    if (edit_mode == 1 || edit_mode == 3) {
        if (edit_mode == 1) layout_struct.y1 += spd;
        if (edit_mode == 3) layout_struct.y2 += spd;
    }
}

// Sauvegarde dans la struct globale (par référence c'est déjà fait, mais on s'assure)
variable_struct_set(global.card_layout, field_name, layout_struct);

// oTutorielManager - Create Event
show_debug_message("### oTutorielManager Created");

// Données du tutoriel (liste d'étapes)
// Chaque étape : { text: "...", highlight: [x, y, w, h] ou noone, arrow: [x, y, angle] ou noone }
steps = [];
current_step = 0;

// Propriétés visuelles
overlay_alpha = 0.8;
window_width = 600;
window_height = 200;
window_color = make_color_rgb(40, 40, 40);
border_color = make_color_rgb(230, 200, 120);
text_color = c_white;

// Bouton Suivant
button_width = 150;
button_height = 40;
button_text = "Suivant";
button_hover = false;

// Police
font = fontCardDisplay;

// Méthode pour configurer les étapes
function setSteps(_steps) {
    steps = _steps;
    current_step = 0;
}

function forceNextStep() {
    current_step++;
    show_debug_message("### oTutorielManager: forceNextStep -> " + string(current_step) + " / " + string(array_length(steps)));
    if (current_step >= array_length(steps)) {
        show_debug_message("### oTutorielManager: Destroying self");
        instance_destroy();
    }
}

function updateHighlight(x, y, w, h) {
    if (current_step < array_length(steps)) {
        steps[current_step].highlight = [x, y, w, h];
    }
}

function updateArrows(arrows) {
    if (current_step < array_length(steps)) {
        steps[current_step].arrow = arrows;
    }
}

function isClickAllowed(click_x, click_y) {
    if (current_step >= array_length(steps)) return true;
    
    var step = steps[current_step];
    
    // Si l'étape désactive les interactions, autoriser uniquement le bouton "Suivant"
    if (variable_struct_exists(step, "allow_clicks") && step.allow_clicks == false) {
        var cam_x = camera_get_view_x(view_camera[0]);
        var cam_y = camera_get_view_y(view_camera[0]);
        var rel_x = click_x - cam_x;
        var rel_y = click_y - cam_y;
        if (instance_exists(oNextStep)) {
            var btn = instance_find(oNextStep, 0);
            if (btn != noone) {
                var bx1 = btn.bbox_left - cam_x;
                var by1 = btn.bbox_top - cam_y;
                var bx2 = btn.bbox_right - cam_x;
                var by2 = btn.bbox_bottom - cam_y;
                return (rel_x >= bx1 && rel_x <= bx2 && rel_y >= by1 && rel_y <= by2);
            }
        }
        return false;
    }
    
    // Si pas de highlight défini, on bloque tout (sauf le bouton Suivant géré par le manager lui-même)
    if (!variable_struct_exists(step, "highlight") || step.highlight == noone) return false;
    
    var h = step.highlight; // [x, y, w, h]
    
    var cam_x = camera_get_view_x(view_camera[0]);
    var cam_y = camera_get_view_y(view_camera[0]);
    
    var rel_x = click_x - cam_x;
    var rel_y = click_y - cam_y;
    
    return (rel_x >= h[0] && rel_x <= h[0] + h[2] && rel_y >= h[1] && rel_y <= h[1] + h[3]);
}

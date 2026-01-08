// oTutorielManager - Draw GUI

if (array_length(steps) == 0) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();

var step = steps[current_step];
var highlight = variable_struct_exists(step, "highlight") ? step.highlight : noone;

// 1. Draw Dimmed Background
draw_set_color(c_black);
draw_set_alpha(overlay_alpha);

if (highlight != noone) {
    // Draw 4 rectangles around the highlight to create a hole
    var hx = highlight[0];
    var hy = highlight[1];
    var hw = highlight[2];
    var hh = highlight[3];
    
    // Top
    if (hy > 0) draw_rectangle(0, 0, gw, hy, false);
    // Bottom
    if (hy + hh < gh) draw_rectangle(0, hy + hh, gw, gh, false);
    // Left
    if (hx > 0) draw_rectangle(0, hy, hx, hy + hh, false);
    // Right
    if (hx + hw < gw) draw_rectangle(hx + hw, hy, gw, hy + hh, false);
} else {
    // Full screen
    draw_rectangle(0, 0, gw, gh, false);
}

draw_set_alpha(1);

// 2. Draw Text Window (Left Aligned)
var wx = 50; // Marge gauche fixe
var wy = (gh - window_height) / 2;

// Fond fenêtre
draw_set_color(window_color);
draw_rectangle(wx, wy, wx + window_width, wy + window_height, false);

// Bordure
draw_set_color(border_color);
draw_rectangle(wx, wy, wx + window_width, wy + window_height, true);

// Texte
draw_set_font(font);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(text_color);
draw_text_ext(wx + window_width/2, wy + window_height/2 - 20, step.text, 30, window_width - 40);

// 3. Draw Button "Suivant"
var hide_next = variable_struct_exists(step, "hide_next_button") && step.hide_next_button;

if (!hide_next) {
    var bx = wx + window_width - button_width - 10;
    var by = wy + window_height - button_height - 10;
    
    // Update hover state
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    button_hover = (mx >= bx && mx <= bx + button_width && my >= by && my <= by + button_height);
    
    var btnColor = button_hover ? make_color_rgb(160, 130, 60) : make_color_rgb(120, 90, 45);
    draw_set_color(btnColor);
    draw_rectangle(bx, by, bx + button_width, by + button_height, false);
    
    draw_set_color(border_color);
    draw_rectangle(bx, by, bx + button_width, by + button_height, true);
    
    draw_set_color(text_color);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(bx + button_width/2, by + button_height/2, button_text);
} else {
    button_hover = false;
}

// 4. Draw Arrow (if any)
if (variable_struct_exists(step, "arrow") && step.arrow != noone) {
    var arrows_list = [];
    if (is_array(step.arrow) && array_length(step.arrow) > 0) {
        if (is_array(step.arrow[0])) {
            arrows_list = step.arrow;
        } else {
            array_push(arrows_list, step.arrow);
        }
    }

    for (var i = 0; i < array_length(arrows_list); i++) {
        var arr = arrows_list[i];
        var ax = arr[0];
        var ay = arr[1];
        var angle = arr[2]; // Direction (0=Right, 90=Up, 180=Left, 270=Down)
        
        draw_set_color(c_red);
        var size = 40;
        
        // Tip at ax, ay
        var tipX = ax;
        var tipY = ay;
        
        // Back points (behind the direction)
        // angle + 180 is "back". Then +/- 30 degrees for width
        var backAngle1 = angle + 180 - 30;
        var backAngle2 = angle + 180 + 30;
        
        var p2x = tipX + lengthdir_x(size, backAngle1);
        var p2y = tipY + lengthdir_y(size, backAngle1);
        var p3x = tipX + lengthdir_x(size, backAngle2);
        var p3y = tipY + lengthdir_y(size, backAngle2);
        
        draw_triangle(tipX, tipY, p2x, p2y, p3x, p3y, false);
    }
}

// Reset
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

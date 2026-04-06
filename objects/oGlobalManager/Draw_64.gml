if (variable_global_exists("admin_mode") && global.admin_mode) {
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(c_red);
    // Utiliser une police par défaut si fontTitle n'existe pas, ou fontTitle
    if (asset_get_index("fontTitle") != -1) {
        draw_set_font(fontTitle);
    }
    
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    
    draw_text(gui_w - 10, gui_h - 10, "ADMIN MODE ACTIVE");
    
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

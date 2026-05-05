if (instance_exists(oPanelOptions) || instance_exists(oQuestPanel)) exit;
var spr = sprite_panel;
var sw = (spr != -1) ? sprite_get_width(spr) : target_w_center;
var sh = (spr != -1) ? sprite_get_height(spr) : target_w_center * (3/2);
var cx = room_width * 0.5;
var off = (sw * scale_center) * 0.5 + gap + (sw * scale_side) * 0.5;
var lx = cx - off;
var rx = cx + off;

var cen_w2 = sw * scale_center;
var cen_h2 = sh * scale_center;
var ixl = cx - cen_w2 * 0.5 + inner_margin_left * cen_w2;
var ixr = cx + cen_w2 * 0.5 - inner_margin_right * cen_w2;
var iyt = panel_y - cen_h2 * 0.5 + inner_margin_top * cen_h2;
var iyb = panel_y + cen_h2 * 0.5 - inner_margin_bottom * cen_h2;
var center_x = (ixl + ixr) * 0.5;
var inner_w = ixr - ixl;
var btn_w = inner_w * btn_start_width_ratio;
var btn_h = btn_start_height;
var btn_x1 = center_x - btn_w * 0.5;
var btn_x2 = center_x + btn_w * 0.5;
var btn_y2 = iyb - btn_start_margin_bottom;
var btn_y1 = btn_y2 - btn_h;

btn_rect_x1 = btn_x1; btn_rect_y1 = btn_y1; btn_rect_x2 = btn_x2; btn_rect_y2 = btn_y2;

var click_start = point_in_rectangle(mouse_x, mouse_y, btn_x1, btn_y1, btn_x2, btn_y2);
var click_center_panel = point_in_rectangle(mouse_x, mouse_y, ixl, iyt, ixr, iyb);
if (click_start || click_center_panel) {
    var chap_id = index + 1;
    
    // Vérification du verrouillage
    if (!is_chapter_unlocked(chap_id)) {
        show_debug_message("### oStoryCarousel: Chapitre " + string(chap_id) + " verrouillé.");
        exit;
    }
    
    var act_to_load = variable_global_exists("current_act") ? max(1, global.current_act) : story_progress_get_resume_act(chap_id);
    var start_scene = 0;
    
    try {
        var resume_act = story_progress_get_resume_act(chap_id);
        if (act_to_load == resume_act) {
            var last = story_progress_read_last_scene(chap_id);
            if (is_struct(last) && variable_struct_exists(last, "act") && variable_struct_exists(last, "scene_index")) {
                if (real(last.act) == act_to_load) start_scene = max(0, real(last.scene_index));
            }
        }
    } catch(e) {
        start_scene = 0;
    }
    global.current_chapter = chap_id;
    global.current_act = act_to_load;
    global.story_resume_info = { chapter_id: chap_id, act: act_to_load, scene_index: start_scene };
    room_goto(rScenario);
}

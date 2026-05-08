// FX_Combat - Create
// Combat animation: attacker approach, impact shake, then resolve

// Expected from spawner (oDamageManager.tryAttack):
// - attacker: attacking card instance (oCardMonster)
// - defender: target card instance (or noone for direct attack)
// - mode: "vsMonster" or "direct"

// Save attacker start position
start_x = (variable_instance_exists(self, "attacker") && attacker != noone) ? attacker.x : x;
start_y = (variable_instance_exists(self, "attacker") && attacker != noone) ? attacker.y : y;

// Resolve target
var tx = start_x;
var ty = start_y;
if (variable_instance_exists(self, "defender") && defender != noone) {
    tx = defender.x; ty = defender.y;
} else {
    // Direct attack: choose target based on attacker side
    if (variable_instance_exists(self, "mode") && mode == "direct") {
        var attacker_is_hero = true;
        if (variable_instance_exists(self, "attacker") && attacker != noone && instance_exists(attacker)) {
            if (variable_instance_exists(attacker, "isHeroOwner")) {
                attacker_is_hero = attacker.isHeroOwner;
            } else {
                // Fallback: infer side from screen position
                attacker_is_hero = (attacker.y >= room_height * 0.5);
            }
        }
        if (attacker_is_hero) {
            // Hero direct attack to enemy
            var btn = instance_find(oAttackDirectEnemy, 0);
            if (btn != noone) {
                tx = btn.x;
                ty = btn.y;
            } else {
                tx = room_width * 0.5;
                ty = 120;
            }
        } else {
            // Enemy direct attack to hero
            var lpHero = instance_find(LP_Hero, 0);
            if (lpHero != noone) {
                tx = lpHero.x;
                ty = lpHero.y;
            } else {
                tx = room_width * 0.5;
                ty = room_height - 120;
            }
        }
    } else {
        // Fallback target: enemy LP indicator
        var lp = instance_find(LP_Enemy, 0);
        if (lp != noone) { tx = lp.x; ty = lp.y; } else { tx = room_width * 0.5; ty = 120; }
    }
}

// Shake target (defender, else enemy LP)
shake_target_inst = (variable_instance_exists(self, "defender") && defender != noone) ? defender : instance_find(LP_Enemy, 0);
if (variable_instance_exists(self, "mode") && mode == "direct") {
    shake_target_inst = noone;
}
shake_target_orig_x = (shake_target_inst != noone) ? shake_target_inst.x : 0;
shake_target_orig_y = (shake_target_inst != noone) ? shake_target_inst.y : 0;

// Compute impact point with margin
var dx = tx - start_x;
var dy = ty - start_y;
var dist = max(1, point_distance(start_x, start_y, tx, ty));
var nx = dx / dist;
var ny = dy / dist;
impact_margin_px = 48;
impact_x = tx - nx * impact_margin_px;
impact_y = ty - ny * impact_margin_px;

// Durations
var game_fps = game_get_speed(gamespeed_fps);
approach_frames = round(0.22 * game_fps);
shake_frames    = round(0.25 * game_fps);
return_frames   = round(0.18 * game_fps);

// Shake amplitude from ATK/PV delta
shake_amp_px = 6;
shake_side = "defender"; // "attacker" | "defender" | "both"
if (variable_instance_exists(self, "defender") && defender != noone && variable_instance_exists(self, "attacker") && attacker != noone) {
    var compareVal = 0;
    if (defender.orientation == "Attack") {
        compareVal = attacker.attack - defender.attack;
    } else {
        compareVal = attacker.attack - defender.PV;
    }
    if (compareVal > 0) shake_side = "defender"; else if (compareVal < 0) shake_side = "attacker"; else shake_side = "both";
    shake_amp_px = clamp(abs(compareVal) / 300, 3, 10);
}

// Save state for restore
attacker_orig_pos_anim = false;
if (variable_instance_exists(self, "attacker") && attacker != noone) {
    if (variable_instance_exists(attacker.id, "position_anim_active") && attacker.position_anim_active) {
        attacker_orig_pos_anim = true;
        attacker.position_anim_active = false;
    }
}

defender_orig_x = (variable_instance_exists(self, "defender") && defender != noone) ? defender.x : 0;
defender_orig_y = (variable_instance_exists(self, "defender") && defender != noone) ? defender.y : 0;
attacker_orig_x = start_x;
attacker_orig_y = start_y;

// Timer/state
_t = 0;
phase = "approach"; // approach -> impact -> resolve -> return -> done
initialized = false;
